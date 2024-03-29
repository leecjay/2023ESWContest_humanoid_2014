'******** 2족 보행로봇 초기 영점 프로그램 ********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM NEW_A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER

DIM 곡선방향 AS BYTE

DIM 넘어진확인 AS BYTE
DIM 기울기확인횟수 AS BYTE
DIM 보행횟수 AS BYTE
DIM 보행COUNT AS BYTE

DIM 적외선거리값  AS BYTE

DIM S11  AS BYTE
DIM S16  AS BYTE
'************************************************
DIM NO_0 AS BYTE
DIM NO_1 AS BYTE
DIM NO_2 AS BYTE
DIM NO_3 AS BYTE
DIM NO_4 AS BYTE

DIM NUM AS BYTE

DIM BUTTON_NO AS INTEGER
DIM SOUND_BUSY AS BYTE
DIM TEMP_INTEGER AS INTEGER

'**** 기울기센서포트 설정 ****
CONST 앞뒤기울기AD포트 = 0
CONST 좌우기울기AD포트 = 1
CONST 기울기확인시간 = 20  'ms

CONST 적외선AD포트  = 4


CONST min = 61	'뒤로넘어졌을때
CONST max = 107	'앞으로넘어졌을때
CONST COUNT_MAX = 3


CONST 머리이동속도 = 10
'************************************************



PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6D,0,1,1,0,1,1		'모터18~23번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,1,1,0		'모터12~17번

'************************************************

OUT 52,0	'머리 LED 켜기
'***** 초기선언 '************************************************

보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
보행횟수 = 1
모터ONOFF = 0

'****초기위치 피드백*****************************


TEMPO 230
MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

SERVO 16, 100


GOSUB 전원초기자세
GOSUB 기본자세


GOSUB 자이로INIT
GOSUB 자이로MID
GOSUB 자이로ON



PRINT "VOLUME 200 !"
PRINT "SOUND 11 !" '안녕

'GOSUB All_motor_mode3 '모든 모터를 강한 상태로 만들어두는 코드


GOTO MAIN	'시리얼 수신 루틴으로 가기

'************************************************

'*********************************************
' Infrared_Distance = 60 ' About 20cm
' Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************
'************************************************
시작음:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
종료음:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
에러음:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '전포트서보모터사용설정

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    모터ONOFF = 0
    GOSUB 시작음			
    RETURN

    '************************************************
    '전포트서보모터사용설정
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '************************************************
    '위치값피드백
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,1,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '위치값피드백
MOTOR_SET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,1,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,1,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,2,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,3,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,1,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,2,2
    RETURN

    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,3,3
    RETURN
    '************************************************

전원초기자세:
    
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0
    RETURN
    '************************************************
안정화자세:
    
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90, 190
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
기본자세:

    SERVO 16, 80
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    mode = 0

    RETURN
    '******************************************	
기본자세2:
    
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT

    mode = 0
    RETURN
    
  	'************************************************
    
세리머니:
 	MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
 	MOVE G6B, 186,  77,  63, 100, 100, 101
	MOVE G6C, 186,  54,  94, 188,  80, 100
	
	TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    
	mode = 0
    RETURN
    

    '************************************************
보행기본자세:

    
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    MOVE G6B,  62,  84,  45, 100, 100, 101
    MOVE G6C, 140,  10,  56, 188,  99, 100


    WAIT
    mode = 0

    RETURN
    '******************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    mode = 2
    RETURN
    '******************************************
앉은자세:
    GOSUB 자이로OFF
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80, 190
    WAIT
    mode = 1

    RETURN
    '******************************************
    '***********************************************
    '***********************************************
    '**** 자이로감도 설정 ****
자이로INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** 자이로감도 설정 ****
자이로MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
자이로MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
자이로MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '***********************************************
자이로ON:

    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    자이로ONOFF = 1

    RETURN
    '***********************************************
자이로OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    자이로ONOFF = 0
    RETURN

    '************************************************

    '******************************************
    '**********************************************
    '**********************************************
RX_EXIT:

    ERX 4800, A, MAIN

    GOTO RX_EXIT
    '**********************************************
GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '**********************************************

    '**********************************************
연속전진_골프:
    보행COUNT = 0
    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        'MOVE G6B,100
        'MOVE G6C,100
        MOVE G6B,  62,  84,  45, 100, 100, 101
        MOVE G6C, 140,  10,  56, 188,  99, 100

        WAIT

        SPEED 10'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        'MOVE G6B,85
        'MOVE G6C,105
        WAIT


        GOTO 연속전진_골프_1	
    ELSE
        보행순서 = 0

        SPEED 4

        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        'MOVE G6C, 100
        'MOVE G6B, 100
        MOVE G6B,  62,  84,  45, 100, 100, 101
        MOVE G6C, 140,  10,  56, 188,  99, 100
        WAIT

        SPEED 10

        MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 147,  93,  96,100
        'MOVE G6C,95
        'MOVE G6B,115
        WAIT


        GOTO 연속전진_골프_2	

    ENDIF


    '*******************************


연속전진_골프_1:

    ETX 4800,11 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT


    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_골프_2
    IF A = 11 THEN
        GOTO 연속전진_골프_2
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 110,100
        'MOVE G6B,115
        'MOVE G6C,95
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        'MOVE G6B, 100
        'MOVE G6C, 100
        WAIT	

        SPEED 2
        GOSUB 보행기본자세

        GOTO RX_EXIT
    ENDIF
    '**********

연속전진_골프_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    'MOVE G6B,115
    'MOVE G6C,95
    WAIT

연속전진_골프_3:
    ETX 4800,11 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_골프_4
    IF A = 11 THEN
        GOTO 연속전진_골프_4
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 146,  93,  96,100
        'MOVE G6B,85
        'MOVE G6C,105
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        'MOVE G6C, 100
        'MOVE G6B, 100
        WAIT	
        SPEED 2
        GOSUB 보행기본자세

        GOTO RX_EXIT
    ENDIF

연속전진_골프_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    'MOVE G6B, 85
    'MOVE G6C,105
    WAIT

    GOTO 연속전진_골프_1
    '*******************************

수정연속전진_골프:
    보행COUNT = 0
    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4

        MOVE G6A, 88,  74, 144,  95, 106
        'MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        'MOVE G6B,100
        'MOVE G6C,100
        MOVE G6B, 104,  48,  98, 100, 100, 101
        MOVE G6C, 186,  10,  14, 190,  99, 100
        WAIT

        SPEED 10'

        MOVE G6A, 90, 80, 120, 95, 110,100
        'MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        MOVE G6B, 85
        'MOVE G6B,90
        'MOVE G6C,110
        WAIT


        GOTO 수정연속전진_골프_1	
    ELSE
        보행순서 = 0

        SPEED 4

        MOVE G6D,  88,  74, 144,  98, 106
        'MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        'MOVE G6C, 100
        'MOVE G6B, 100
        MOVE G6B, 104,  48,  98, 100, 100, 101
        MOVE G6C, 186,  10,  14, 190,  99, 100
        WAIT

        SPEED 10

        MOVE G6D, 90, 93, 120, 108, 106,100
        'MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 147,  90,  96,100
        MOVE G6B, 115
        'MOVE G6C,90
        'MOVE G6B,110
        WAIT


        GOTO 수정연속전진_골프_2	

    ENDIF


    '*******************************


수정연속전진_골프_1:

    ETX 4800,11 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 103, 106
    'MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  97,  96
    'MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 104, 145,  67, 106
    'MOVE G6D,86, 100, 145,  69, 110
    WAIT


    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 수정연속전진_골프_2
    IF A = 11 THEN
        GOTO 수정연속전진_골프_2
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 104, 100, 117, 106,100
        'MOVE G6D,90, 100, 100, 115, 110,100
        'MOVE G6B,110
        'MOVE G6C,90
        MOVE G6B,115
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 102,100
        'MOVE G6D,  88,  71, 152,  91, 106,100
        'MOVE G6B, 100
        'MOVE G6C, 100
        MOVE G6B, 100
        WAIT	

        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF
    '**********


수정연속전진_골프_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 93, 120, 106, 106,100
    'MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,115
    'MOVE G6B,110
    'MOVE G6C,90
    WAIT

수정연속전진_골프_3:
    ETX 4800,11 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 117, 106
    'MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    'MOVE G6A,86, 100, 145,  69, 110
    MOVE G6A,86, 100, 145,  67, 106
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 수정연속전진_골프_4
    IF A = 11 THEN
        GOTO 수정연속전진_골프_4
    ELSE

        'MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6A, 90, 90, 100, 103, 106,100
        MOVE G6D,112,  76, 146,  97,  96,100
        'MOVE G6D,112,  76, 146,  93,  96,100
        MOVE G6B,85
        'MOVE G6B,90
        'MOVE G6C,110
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 147,  91, 102,100
        'MOVE G6A,  88,  71, 152,  91, 106,100
        'MOVE G6C, 100
        'MOVE G6B, 100
        MOVE G6B, 100
        WAIT	
        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF

수정연속전진_골프_4:
    '왼발들기10
    MOVE G6A,90, 80, 120, 95, 106,100
    'MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    'MOVE G6B, 90
    'MOVE G6C,110
    MOVE G6B, 85
    WAIT

    GOTO 수정연속전진_골프_1
    '*******************************



    '************************************************
연속후진_골프:
    넘어진확인 = 0
    보행속도 = 12
    좌우속도 = 4
    GOSUB Leg_motor_mode3



    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        MOVE G6A, 88,  71, 152,  91, 110
        MOVE G6D,108,  76, 145,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 10
        MOVE G6A, 90, 100, 100, 115, 110
        MOVE G6D,110,  76, 145,  93,  96
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        GOTO 연속후진_골프_1	
    ELSE
        보행순서 = 0

        SPEED 4
        MOVE G6D,  85,  71, 152,  91, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 10
        MOVE G6D, 90, 100, 100, 115, 110
        MOVE G6A,112,  76, 146,  93,  96
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO 연속후진_골프_2

    ENDIF

    '*************************************
연속후진_골프_1:
    ETX 4800,12 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6D,110,  76, 146, 93,  96
    MOVE G6A,90, 98, 146,  69, 110
    WAIT

    SPEED 좌우속도
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, 연속후진_골프_2
    IF A <> A_old THEN
연속후진_골프_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 108,  76, 146,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB 기본자세2
        GOTO RX_EXIT
    ENDIF
    '**********

연속후진_골프_2:
    ETX 4800,12 '진행코드를 보냄
    SPEED 보행속도
    MOVE G6A,112,  76, 146, 93,  96
    MOVE G6D,90, 98, 146,  69, 110
    WAIT


    SPEED 좌우속도
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,110,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT


    ERX 4800,A, 연속후진_골프_1
    IF A <> A_old THEN
연속후진_골프_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 146,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB 기본자세2
        GOTO RX_EXIT
    ENDIF  	

    GOTO 연속후진_골프_1
    '**********************************************


    '******************************************

    '******************************************
전진종종걸음_골프:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음_골프_1
    ELSE
        보행순서 = 0
        MOVE G6D,93,  76, 147,  93, 101
        MOVE G6A,104,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음_골프_4
    ENDIF


    '**********************

전진종종걸음_골프_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,103,  76, 146,  93,  102
    MOVE G6B, 85
    MOVE G6C,105
    'MOVE G6B, 90
    'MOVE G6C,115
    WAIT


전진종종걸음_골프_2:

    MOVE G6A,107,   73, 140, 103,  100
    MOVE G6D, 90,  83, 146,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_골프_2_stop

    ERX 4800,A, 전진종종걸음_골프_4
    IF A <> A_old THEN
전진종종걸음_골프_2_stop:
        MOVE G6D,93,  90, 125, 95, 104
        MOVE G6A,107,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

전진종종걸음_골프_4:
    MOVE G6D,95,  88, 125, 103, 104
    MOVE G6A,107,  76, 146,  93,  102
    MOVE G6C, 95
    MOVE G6B,115
    'MOVE G6C, 85
    'MOVE G6B,110
    WAIT


전진종종걸음_골프_5:
    MOVE G6D,102,    74, 140, 103,  100
    MOVE G6A, 97,  83, 146,  85, 102
    WAIT
    'DELAY 10

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_골프_5_stop

    ERX 4800,A, 전진종종걸음_골프_1
    IF A <> A_old THEN
전진종종걸음_골프_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO 전진종종걸음_골프_1

    '******************************************
    '******************************************
    '******************************************
후진종종걸음_골프:
    GOSUB All_motor_mode3
    넘어진확인 = 0
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 후진종종걸음_골프_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 후진종종걸음_골프_4
    ENDIF


    '**********************

후진종종걸음_골프_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT



후진종종걸음_골프_3:
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF
    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 후진종종걸음_골프_3_stop

    ERX 4800,A, 후진종종걸음_골프_4
    IF A <> A_old THEN
후진종종걸음_골프_3_stop:
        MOVE G6D,95,  85, 130, 100, 104
        MOVE G6A,104,  77, 146,  93,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        'SPEED 15
        GOSUB 안정화자세
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

후진종종걸음_골프_4:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6C,115
    MOVE G6B,85
    WAIT


후진종종걸음_골프_6:
    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 후진종종걸음_골프_6_stop

    ERX 4800,A, 후진종종걸음_골프_1
    IF A <> A_old THEN  'GOTO 후진종종걸음_멈춤
후진종종걸음_골프_6_stop:
        MOVE G6A,95,  85, 130, 100, 104
        MOVE G6D,104,  77, 146,  93,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT

        'SPEED 15
        GOSUB 안정화자세
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    GOTO 후진종종걸음_골프_1




    '******************************************
채내리기: '****

    SPEED 12
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  50,  80, 50
    WAIT

    GOTO RX_EXIT




오른쪽옆으로10_골프: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 105, 100
    MOVE G6A,107,  77, 147,  93, 105 , 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 105, 100
    WAIT

    SPEED 12
    MOVE G6D,95,  76, 147,  93, 98, 100
    MOVE G6A,95,  76, 147,  93, 98, 100
    WAIT

    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT

왼쪽옆으로10_골프: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 103, 100
    MOVE G6D,107,  77, 147,  93, 103, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 147, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 103, 100
    WAIT

    SPEED 12
    MOVE G6D,95,  76, 147,  93, 98, 100
    MOVE G6A,95,  76, 147,  93, 98, 100
    WAIT

    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT




    '************************************************
오른쪽옆으로20_골프: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 107, 100
    MOVE G6A,107,  77, 147,  93, 107 , 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 12
    MOVE G6D,95,  76, 147,  93, 98, 100
    MOVE G6A,95,  76, 147,  93, 98, 100
    WAIT

    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT
    '************************************************

왼쪽옆으로20_골프: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 8
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 8
    MOVE G6A, 102,  76, 146, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 8
    MOVE G6A,95,  76, 146,  93, 98, 100
    MOVE G6D,95,  76, 146,  93, 98, 100
    WAIT

    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT

    '**********************************************
    '******************************************
오른쪽옆으로70연속_골프:
    MOTORMODE G6A,3,3,2,3,2
    MOTORMODE G6D,3,3,2,3,2

오른쪽옆으로70연속_골프_loop:
    DELAY  10

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,103,  77, 147,  93, 107, 100
    WAIT

    SPEED 13
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,83,  77, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6D,98,  77, 147,  93, 100, 100
    MOVE G6A,98,  77, 147,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    WAIT


    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************

왼쪽옆으로70연속_골프:
    MOTORMODE G6A,3,3,2,3,2
    MOTORMODE G6D,3,3,2,3,2
왼쪽옆으로70연속_골프_loop:
    DELAY  10

    SPEED 10
    MOVE G6A, 90,  90, 120, 95, 110, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    WAIT

    SPEED 13
    MOVE G6A, 102,  76, 146, 93, 100, 100
    MOVE G6D,83,  79, 140,  99, 115, 100
    WAIT

    SPEED 13
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT


    SPEED 3
    GOSUB 기본자세2

    GOTO RX_EXIT

    '**********************************************
    '************************************************
    '*********************************************

왼쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴3_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 6
        MOVE G6D,100,  84, 145,  78, 100, 100
        MOVE G6A,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,90,  90, 145,  78, 102, 100
        MOVE G6A,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6D,90,  80, 130, 102, 104
        MOVE G6A,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6D,100,  88, 145,  78, 100, 100
        MOVE G6A,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,104,  86, 146,  80, 100, 100
        MOVE G6A,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  85, 130, 98, 104
        MOVE G6D,105,  77, 146,  93,  100
        WAIT



    ENDIF

    SPEED 12
    GOSUB 기본자세2


    GOTO RX_EXIT

    '**********************************************
오른쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

오른쪽턴3_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  84, 145,  78, 100, 100
        MOVE G6D,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,90,  90, 145,  78, 102, 100
        MOVE G6D,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6A,90,  80, 130, 102, 104
        MOVE G6D,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  88, 145,  78, 100, 100
        MOVE G6D,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,104,  86, 146,  80, 100, 100
        MOVE G6D,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,90,  85, 130, 98, 104
        MOVE G6A,105,  77, 146,  93,  100
        WAIT

    ENDIF
    SPEED 12
    GOSUB 기본자세2

    GOTO RX_EXIT

    '******************************************************
    '**********************************************
왼쪽턴5_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,100,  81, 145,  88, 106, 100
    MOVE G6D,94,  71, 145, 98, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,97,  81, 145,  88, 104, 100
    MOVE G6D,91,  71, 145, 98, 96, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2
    GOTO RX_EXIT
    '**********************************************
오른쪽턴5_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  71, 145,  98, 103, 100
    MOVE G6D,97,  81, 145,  88, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  71, 145,  98, 101, 100
    MOVE G6D,94,  81, 145,  88, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************

    '**********************************************
왼쪽턴10_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,100,  86, 145,  83, 106, 100
    MOVE G6D,94,  66, 145, 103, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,97,  86, 145,  83, 104, 100
    MOVE G6D,91,  66, 145, 103, 96, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2
    GOTO RX_EXIT
    '**********************************************
오른쪽턴10_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
    '**********************************************
왼쪽턴20_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 108, 100
    MOVE G6D,91,  56, 145,  113, 102, 100
    WAIT

    SPEED 12
    MOVE G6A,91,  96, 145,  73, 108, 100
    MOVE G6D,88,  56, 145,  113, 102, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
오른쪽턴20_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************

    '**********************************************	


    '**********************************************
왼쪽턴45_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 10
    MOVE G6A,95,  106, 145,  63, 108, 100
    MOVE G6D,91,  46, 145,  123, 102, 100
    WAIT

    SPEED 12
    MOVE G6A,91,  106, 145,  63, 108, 100
    MOVE G6D,88,  46, 145,  123, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2

    '
    GOTO RX_EXIT

    '**********************************************
오른쪽턴45_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
왼쪽턴60_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 15
    MOVE G6A,95,  116, 145,  53, 108, 100
    MOVE G6D,91,  36, 145,  133, 102, 100
    WAIT

    SPEED 15
    MOVE G6A,91,  116, 145,  53, 108, 100
    MOVE G6D,88,  36, 145,  133, 102, 100
    WAIT

    SPEED 10
    GOSUB 기본자세2

    GOTO RX_EXIT

    '**********************************************
오른쪽턴60_골프:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2


    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세2

    GOTO RX_EXIT
    '****************************************
    '************************************************
    '**********************************************


    '************************************************

    ''************************************************
    '************************************************
    '************************************************
뒤로일어나기:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB 자이로OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB 기본자세

    MOVE G6A,90, 130, 120,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 190, 100, 100
    WAIT

    MOVE G6B,185, 160,  10, 100, 100, 100
    MOVE G6C,185, 160,  10, 190, 100, 100
    WAIT

    SPEED 12
    MOVE G6B,185,  50, 10,  100, 100, 100
    MOVE G6C,185,  50, 10,  190, 100, 100
    WAIT



    SPEED 10
    MOVE G6A, 80, 155,  80, 150, 150, 100
    MOVE G6D, 80, 155,  80, 150, 150, 100
    MOVE G6B,185,  20, 50,  100, 100, 100
    MOVE G6C,185,  20, 50,  190, 100, 100
    WAIT

    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  55, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 190, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 190, 100, 100
    WAIT

    DELAY 200


    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 190, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 190, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10
    GOSUB 기본자세

    넘어진확인 = 1

    DELAY 200
    GOSUB 자이로ON

    RETURN


    '**********************************************
앞으로일어나기:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 35,  70, 130, 100,
    MOVE G6D,100, 35,  70, 130, 100,
    MOVE G6B,15,  140,  15
    MOVE G6C,15,  140,  15
    WAIT

    SPEED 12
    MOVE G6B,15,  100,  10
    MOVE G6C,15,  100,  10
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,15,  15,  75
    MOVE G6C,15,  15,  75
    WAIT

    SPEED 10
    MOVE G6A,100, 165,  75, 20, 100,
    MOVE G6D,100, 165,  75, 20, 100,
    MOVE G6B,15,  20,  95
    MOVE G6C,15,  20,  95
    WAIT

    DELAY 200

    GOSUB Leg_motor_mode3

    SPEED 8
    MOVE G6A,100, 165,  85, 20, 100,
    MOVE G6D,100, 165,  85, 20, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 8
    MOVE G6A,100, 165,  85, 30, 100,
    MOVE G6D,100, 165,  85, 30, 100,
    WAIT

    SPEED 8
    MOVE G6A,100, 155,  45, 110, 100,
    MOVE G6D,100, 155,  45, 110, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 6
    MOVE G6A,100, 145,  45, 130, 100,
    MOVE G6D,100, 145,  45, 130, 100,
    WAIT


    SPEED 8
    GOSUB All_motor_mode2
    GOSUB 기본자세
    넘어진확인 = 1

    '******************************
    DELAY 200
    GOSUB 자이로ON
    RETURN

    '******************************************
    '******************************************
    '******************************************
    '**************************************************

    '******************************************
    '******************************************	
    '**********************************************

머리왼쪽30도:
    SPEED 머리이동속도
    SERVO 11,70
    GOTO RX_EXIT

머리왼쪽45도:
    SPEED 머리이동속도
    SERVO 11,55
    GOTO RX_EXIT

머리왼쪽60도:
    SPEED 머리이동속도
    SERVO 11,40
    GOTO RX_EXIT

머리왼쪽90도:
    SPEED 머리이동속도
    SERVO 11,10
    GOTO RX_EXIT

머리오른쪽30도:
    SPEED 머리이동속도
    SERVO 11,130
    GOTO RX_EXIT

머리오른쪽45도:
    SPEED 머리이동속도
    SERVO 11,145
    GOTO RX_EXIT	

머리오른쪽60도:
    SPEED 머리이동속도
    SERVO 11,160
    GOTO RX_EXIT

머리오른쪽90도:
    SPEED 머리이동속도
    SERVO 11,190
    GOTO RX_EXIT

머리좌우중앙:
    SPEED 머리이동속도
    SERVO 11,100
    GOTO RX_EXIT

머리상하정면:
    SPEED 머리이동속도
    SERVO 16,100	
    SPEED 5
    GOSUB 기본자세
    GOTO RX_EXIT
    '******************************************
머리정면:
    SPEED 머리이동속도
    SERVO 11,100
    SERVO 16,100	
    SPEED 5
    GOSUB 기본자세
    GOTO RX_EXIT

    '******************************************
전방하향80도:

    SPEED 3
    SERVO 16, 80
    SERVO 11, 100
    GOTO RX_EXIT

    '***********************userdefine*******************
하향10도:

    SPEED 3
    SERVO 16, 90
    GOTO RX_EXIT

    '***********************userdefine*******************
하향15도:

    SPEED 3
    SERVO 16, 85
    GOTO RX_EXIT

    '***********************userdefine*******************
하향20도:

    SPEED 3
    SERVO 16, 80
    GOTO RX_EXIT

    '***********************userdefine*******************
하향25도:

    SPEED 3
    SERVO 16, 75
    GOTO RX_EXIT

    '***********************userdefine*******************
하향30도:

    SPEED 3
    SERVO 16, 70
    GOTO RX_EXIT

    '***********************userdefine*******************
하향35도:

    SPEED 3
    SERVO 16, 65
    GOTO RX_EXIT

    '***********************userdefine*******************
하향40도:

    SPEED 3
    SERVO 16, 60
    GOTO RX_EXIT

    '***********************userdefine*******************
하향45도:

    SPEED 3
    SERVO 16, 55
    GOTO RX_EXIT

    '***********************userdefine*******************
하향50도:

    SPEED 3
    SERVO 16, 50
    GOTO RX_EXIT
    '***********************userdefine*******************
하향55도:

    SPEED 3
    SERVO 16, 45
    GOTO RX_EXIT

    '***********************userdefine*******************
하향60도:

    SPEED 3
    SERVO 16, 40
    GOTO RX_EXIT
    '***********************userdefine*******************
하향65도:

    SPEED 3
    SERVO 16, 35
    GOTO RX_EXIT

    '***********************userdefine*******************
하향70도:

    SPEED 3
    SERVO 16, 30
    GOTO RX_EXIT	

    '***********************userdefine*******************
하향75도:

    SPEED 3
    SERVO 16, 25
    GOTO RX_EXIT

    '***********************userdefine*******************
하향80도:

    SPEED 3
    SERVO 16, 20
    GOTO RX_EXIT	

    '***********************userdefine*******************
하향85도:

    SPEED 3
    SERVO 16, 15
    GOTO RX_EXIT

    '***********************userdefine*******************
하향90도:

    SPEED 3
    SERVO 16, 10
    GOTO RX_EXIT	

    '******************************************
전방하향60도:

    SPEED 3
    SERVO 16, 65
    SERVO 11, 100
    ETX 4800,36
    GOTO RX_EXIT

    '******************************************
    '******************************************
앞뒤기울기측정:
    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN
        GOSUB 기울기앞
    ELSEIF A > MAX THEN
        GOSUB 기울기뒤
    ENDIF

    RETURN
    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN
        ETX  4800,16
        GOSUB 뒤로일어나기

    ENDIF
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN
        ETX  4800,15
        GOSUB 앞으로일어나기
    ENDIF
    RETURN
    '**************************************************
좌우기울기측정:
    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
    ENDIF
    RETURN
    '******************************************
    '************************************************
SOUND_PLAY_CHK:
    DELAY 60
    SOUND_BUSY = IN(46)
    IF SOUND_BUSY = 1 THEN GOTO SOUND_PLAY_CHK
    DELAY 50

    RETURN
    '************************************************

    '************************************************
NUM_1_9:
    IF NUM = 1 THEN
        PRINT "1"
    ELSEIF NUM = 2 THEN
        PRINT "2"
    ELSEIF NUM = 3 THEN
        PRINT "3"
    ELSEIF NUM = 4 THEN
        PRINT "4"
    ELSEIF NUM = 5 THEN
        PRINT "5"
    ELSEIF NUM = 6 THEN
        PRINT "6"
    ELSEIF NUM = 7 THEN
        PRINT "7"
    ELSEIF NUM = 8 THEN
        PRINT "8"
    ELSEIF NUM = 9 THEN
        PRINT "9"
    ELSEIF NUM = 0 THEN
        PRINT "0"
    ENDIF

    RETURN
    '************************************************
    '************************************************
NUM_TO_ARR:

    NO_4 =  BUTTON_NO / 10000
    TEMP_INTEGER = BUTTON_NO MOD 10000

    NO_3 =  TEMP_INTEGER / 1000
    TEMP_INTEGER = BUTTON_NO MOD 1000

    NO_2 =  TEMP_INTEGER / 100
    TEMP_INTEGER = BUTTON_NO MOD 100

    NO_1 =  TEMP_INTEGER / 10
    TEMP_INTEGER = BUTTON_NO MOD 10

    NO_0 =  TEMP_INTEGER

    RETURN
    '************************************************
Number_Play: '  BUTTON_NO = 숫자대입


    GOSUB NUM_TO_ARR

    PRINT "NPL "
    '*************

    NUM = NO_4
    GOSUB NUM_1_9

    '*************
    NUM = NO_3
    GOSUB NUM_1_9

    '*************
    NUM = NO_2
    GOSUB NUM_1_9
    '*************
    NUM = NO_1
    GOSUB NUM_1_9
    '*************
    NUM = NO_0
    GOSUB NUM_1_9
    PRINT " !"

    ' GOSUB SOUND_PLAY_CHK
    '    PRINT "SND 16 !"
    '    GOSUB SOUND_PLAY_CHK
    RETURN
    '************************************************

    RETURN


    '******************************************

    ' ************************************************
적외선거리센서확인:

    적외선거리값 = AD(적외선AD포트)

    IF 적외선거리값 > 50 THEN '50 = 적외선거리값 = 25cm
        MUSIC "C"
        DELAY 200
    ENDIF


    RETURN

    '******************************************
변수값_음성값출력:

    J = AD(적외선AD포트)	'적외선거리값 읽기
    BUTTON_NO = J
    GOSUB Number_Play
    GOSUB SOUND_PLAY_CHK
    GOSUB GOSUB_RX_EXIT


    RETURN

    '************************************************
골프_왼쪽으로_샷1:

    CONST 골프채높이 = 135

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT

    MOVE G6C,135,  20,  90, 10
    WAIT

    DELAY 400


    MOVE G6C,135,  40,  90, 10
    WAIT

    '**** 골프 _왼쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 8
    MOVE G6C,135,  10,  70, 10
    WAIT
    DELAY 1000
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,135,  100,  10, 10
    WAIT

    MOVE G6C,135,  50,  60, 190
    WAIT

    GOSUB 기본자세

    RETURN
    '******************************************


골프_왼쪽으로_어드레스1:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT


    MOVE G6C,135,  20,  90, 10
    WAIT

    RETURN
    '******************************************

    '************************************************
골프_오른쪽으로_샷1:

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  130,  10, 10
    WAIT

    MOVE G6C,145,  130,  10, 10
    WAIT

    MOVE G6C,145,  60,  10, 10
    WAIT

    MOVE G6C,135,  40,  30, 10
    WAIT


    MOVE G6C,140,  10,  80, 10
    WAIT

    DELAY 400

    MOVE G6B,100,  35,  90,
    MOVE G6C,140,  10,  70, 10
    WAIT


    '**** 골프 _오른쪽으로_샷 스피드 *******
    'HIGHSPEED SETON
    SPEED 3

    MOVE G6C,140,  30,  100, 10
    WAIT
    DELAY 1000
    ' HIGHSPEED SETOFF

    '************

    SPEED 8
    MOVE G6C,135,  50,  60, 190
    WAIT

    GOSUB 기본자세

    RETURN
    '******************************************


골프_오른쪽으로_어드레스1:
    GOSUB All_motor_mode3

    SPEED 8
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,150,  100,  10, 10
    WAIT


    MOVE G6C,135,  40,  40, 10
    WAIT

    MOVE G6C,135,  10,  80, 10
    WAIT


    RETURN
    '******************************************
    '******************************************	
MAIN: '라벨설정

    ETX 4800, 38 ' 동작 멈춤 확인 송신 값

MAIN_2:

    'GOSUB 앞뒤기울기측정'Turn on this at the competition
    'GOSUB 좌우기울기측정'Turn on this at the competition
    'GOSUB 적외선거리센서확인


    ERX 4800,A,MAIN_2	

    A_old = A

    '**** 입력된 A값이 0 이면 MAIN 라벨로 가고
    '**** 1이면 KEY1 라벨, 2이면 key2로... 가는문
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

    'IF A > 100 AND A < 110 THEN
    'BUTTON_NO = A - 100
    'GOSUB Number_Play
    'GOSUB SOUND_PLAY_CHK
    'GOSUB GOSUB_RX_EXIT

    IF A > 100 AND A < 121 THEN
        NEW_A = A-101
        ON NEW_A GOTO KEY101, KEY102, KEY103, KEY104, KEY105, KEY106, KEY107, KEY108, KEY109, KEY110, KEY111, KEY112, KEY113, KEY114, KEY115, KEY116, KEY117, KEY118, KEY119, KEY120
    ELSEIF A > 120 AND A < 141 THEN
        NEW_A = A-120
        ON NEW_A GOTO KEY121, KEY122, KEY123, KEY124, KEY125, KEY126, KEY127, KEY128, KEY129, KEY130, KEY131, KEY132, KEY133, KEY134, KEY135, KEY136, KEY137, KEY138, KEY139, KEY140
    ELSEIF A > 140 AND A < 161 THEN
        NEW_A = A-140
        ON NEW_A GOTO KEY141, KEY142, KEY143, KEY144, KEY145, KEY146, KEY147, KEY148, KEY149, KEY150, KEY151, KEY152, KEY153, KEY154, KEY155, KEY156, KEY157, KEY158, KEY159, KEY160

    ELSEIF A = 220 THEN
        GOSUB All_motor_mode3
        SPEED 6
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  30,  90,
        MOVE G6C,100,  30,  70, 180
        WAIT
        DELAY 500
        SPEED 6
        GOSUB 기본자세

    ELSEIF A = 250 THEN
        GOSUB All_motor_mode3
        SPEED 4
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  40,  90,
        MOVE G6C,100,  40,  90,
        WAIT
        DELAY 500
        SPEED 6
        GOSUB 기본자세

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************

KEY1:
    ETX  4800,1
    GOTO 왼쪽턴5_골프


    GOTO RX_EXIT
    '***************	
KEY2:
    ETX  4800,2


    GOSUB 골프_왼쪽으로_샷1


    GOTO RX_EXIT	
    '***************
KEY3:
    ETX  4800,3

    GOTO 오른쪽턴5_골프

    GOTO RX_EXIT
    '***************
KEY4:
    ETX  4800,4

    GOTO 왼쪽턴10_골프

    GOTO RX_EXIT
    '***************
KEY5:
    ETX  4800,5

    GOSUB 골프_오른쪽으로_샷1



    GOTO RX_EXIT
    '***************
KEY6:
    ETX  4800,6

    GOTO 오른쪽턴10_골프


    GOTO RX_EXIT
    '***************
KEY7:
    ETX  4800,7
    GOTO 왼쪽턴20_골프

    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8


    GOTO RX_EXIT
    '***************
KEY9:
    ETX  4800,9
    GOTO 오른쪽턴20_골프


    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX  4800,10
    GOTO 전진종종걸음_골프

    GOTO RX_EXIT
    '***************
KEY11: ' ▲
    ETX  4800,11

    GOTO 연속전진_골프

    GOTO RX_EXIT


    '***************
KEY12: ' ▼
    ETX  4800,12
    GOTO 연속후진_골프

    GOTO RX_EXIT
    '***************
KEY13: '▶
    ETX  4800,13
    GOTO 오른쪽옆으로70연속_골프


    GOTO RX_EXIT
    '***************
KEY14: ' ◀
    ETX  4800,14
    GOTO 왼쪽옆으로70연속_골프


    GOTO RX_EXIT
    '***************
KEY15: ' A
    ETX  4800,15
    GOTO 왼쪽옆으로20_골프


    GOTO RX_EXIT
    '***************
KEY16: ' POWER
    ETX  4800,16

    GOSUB Leg_motor_mode3
    IF MODE = 0 THEN
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
    ENDIF
    SPEED 4
    GOSUB 앉은자세	
    GOSUB 종료음

    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF


    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF 모터ONOFF = 1  THEN
        OUT 52,1
        DELAY 200
        OUT 52,0
        DELAY 200
    ENDIF
    ERX 4800,A,KEY16_1
    ETX  4800,A

    '**** RX DATA Number Sound ********
    BUTTON_NO = A
    GOSUB Number_Play
    GOSUB SOUND_PLAY_CHK


    IF  A = 16 THEN 	'다시 파워버튼을 눌러야만 복귀
        GOSUB MOTOR_ON
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT

        GOSUB 기본자세2
        GOSUB 자이로ON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1



    GOTO RX_EXIT
    '***************
KEY17: ' C
    ETX  4800,17
    GOTO 머리왼쪽90도


    GOTO RX_EXIT
    '***************
KEY18: ' E
    ETX  4800,18	


    GOSUB 자이로OFF
    GOSUB 에러음
KEY18_wait:

    ERX 4800,A,KEY18_wait	

    IF  A = 26 THEN
        GOSUB 시작음
        GOSUB 자이로ON
        GOTO RX_EXIT
    ENDIF

    GOTO KEY18_wait


    GOTO RX_EXIT
    '***************
KEY19: ' P2
    ETX  4800,19
    GOTO 오른쪽턴60_골프

    GOTO RX_EXIT
    '***************
KEY20: ' B	
    ETX  4800,20
    GOTO 오른쪽옆으로20_골프


    GOTO RX_EXIT
    '***************
KEY21: ' △
    ETX  4800,21
    GOTO 머리좌우중앙

    GOTO RX_EXIT
    '***************
KEY22: ' *	
    ETX  4800,22
    GOTO 왼쪽턴45_골프

    GOTO RX_EXIT
    '***************
KEY23: ' G
    ETX  4800,23



    GOTO RX_EXIT
    '***************
KEY24: ' #
    ETX  4800,24
    GOTO 오른쪽턴45_골프

    GOTO RX_EXIT
    '***************
KEY25: ' P1
    ETX  4800,25
    GOTO 왼쪽턴60_골프

    GOTO RX_EXIT
    '***************
KEY26: ' ■
    ETX  4800,26

    SPEED 5
    GOSUB 기본자세2	
    TEMPO 220
    MUSIC "ff"
    GOSUB 기본자세
    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX  4800,27
    GOTO 머리오른쪽90도

    GOTO RX_EXIT
    '***************
KEY28: ' ◁
    ETX  4800,28
    GOTO 머리왼쪽45도


    GOTO RX_EXIT
    '***************
KEY29: ' □
    ETX  4800,29

    GOTO 하향60도

    GOTO RX_EXIT
    '***************
KEY30: ' ▷
    ETX  4800,30
    GOTO 머리오른쪽45도

    GOTO RX_EXIT
    '***************
KEY31: ' ▽
    ETX  4800,31
    SPEED 3
    SERVO 16, 80
    SERVO 11, 100
    GOTO RX_EXIT
    '***************

KEY32: ' F
    ETX  4800,32
    GOTO 머리정면
    GOTO RX_EXIT

    '******head********
    '******origin********
KEY101:
    ETX  4800,101
    GOTO 머리정면
    GOTO RX_EXIT
    '******down********
KEY102:
    ETX  4800,102
    GOTO 하향10도
    GOTO RX_EXIT
KEY103:
    ETX  4800,103
    GOTO 하향15도
    GOTO RX_EXIT
KEY104:
    ETX  4800,104
    GOTO 하향20도
    GOTO RX_EXIT
KEY105:
    ETX  4800,105
    GOTO 하향25도
    GOTO RX_EXIT
KEY106:
    ETX  4800,106
    GOTO 하향30도
    GOTO RX_EXIT
KEY107:
    ETX  4800,107
    GOTO 하향35도
    GOTO RX_EXIT
KEY108:
    ETX  4800,108
    GOTO 하향40도
    GOTO RX_EXIT
KEY109:
    ETX  4800,109
    GOTO 하향45도
    GOTO RX_EXIT
KEY110:
    ETX  4800,110
    GOTO 하향50도
    GOTO RX_EXIT
KEY111:
    ETX  4800,111
    GOTO 하향55도
    GOTO RX_EXIT
KEY112:
    ETX  4800,112
    GOTO 하향60도
    GOTO RX_EXIT
KEY113:
    ETX  4800,113
    GOTO 하향65도
    GOTO RX_EXIT
KEY114:
    ETX  4800,114
    GOTO 하향70도
    GOTO RX_EXIT
KEY115:
    ETX  4800,115
    GOTO 하향75도
    GOTO RX_EXIT
KEY116:
    ETX  4800,116
    GOTO 하향80도
    GOTO RX_EXIT
KEY117:
    ETX  4800,117
    GOTO 하향85도
    GOTO RX_EXIT
KEY118:
    ETX  4800,118
    GOTO 하향90도
    GOTO RX_EXIT
KEY119:
    ETX  4800,119
    SPEED 5
    GOSUB 세리머니 
    GOTO RX_EXIT
KEY120:
    ETX  4800,120
    SPEED 3
    SERVO 16,81
    GOTO RX_EXIT
KEY121:
    ETX  4800,121
    SPEED 3
    SERVO 16,80
    GOTO RX_EXIT
KEY122:
    ETX  4800,122
    SPEED 3
    SERVO 16,79
    GOTO RX_EXIT
KEY123:
    ETX  4800,123
    SPEED 3
    SERVO 16,78
    GOTO RX_EXIT
KEY124:
    ETX  4800,124
    SPEED 3
    SERVO 16,77
    GOTO RX_EXIT
KEY125:
    ETX  4800,125
    SPEED 3
    SERVO 16,76
    GOTO RX_EXIT
KEY126:
    ETX  4800,126
    SPEED 3
    SERVO 16,75
    GOTO RX_EXIT
KEY127:
    ETX  4800,127
    SPEED 3
    SERVO 16,74
    GOTO RX_EXIT
KEY128:
    ETX  4800,128
    SPEED 3
    SERVO 16,73
    GOTO RX_EXIT
KEY129:
    ETX  4800,129
    SPEED 3
    SERVO 16,72
    GOTO RX_EXIT
KEY130:
    ETX  4800,130
    SPEED 3
    SERVO 16,71
    GOTO RX_EXIT
KEY131:
    ETX  4800,131
    SPEED 3
    SERVO 16,70
    GOTO RX_EXIT
KEY132:
    ETX  4800,132
    SPEED 3
    SERVO 16,69
    GOTO RX_EXIT
KEY133:
    ETX  4800,133
    SPEED 3
    SERVO 16,68
    GOTO RX_EXIT
KEY134:
    ETX  4800,134
    SPEED 3
    SERVO 16,67
    GOTO RX_EXIT
KEY135:
    ETX  4800,135
    SPEED 3
    SERVO 16,66
    GOTO RX_EXIT
KEY136:
    ETX  4800,136
    SPEED 3
    SERVO 16,65
    GOTO RX_EXIT
KEY137:
    ETX  4800,137
    SPEED 3
    SERVO 16,64
    GOTO RX_EXIT
KEY138:
    ETX  4800,138
    SPEED 3
    SERVO 16,63
    GOTO RX_EXIT
KEY139:
    ETX  4800,139
    SPEED 3
    SERVO 16,62
    GOTO RX_EXIT
KEY140:
    ETX  4800,140
    SPEED 3
    SERVO 16,61
    GOTO RX_EXIT
KEY141:
    ETX  4800,141
    SPEED 3
    SERVO 16,60
    GOTO RX_EXIT
KEY142:
    ETX  4800,142
    SPEED 3
    SERVO 16,59
    GOTO RX_EXIT
KEY143:
    ETX  4800,143
    SPEED 3
    SERVO 16,58
    GOTO RX_EXIT
KEY144:
    ETX  4800,144
    SPEED 3
    SERVO 16,57
    GOTO RX_EXIT
KEY145:
    ETX  4800,145
    SPEED 3
    SERVO 16,56
    GOTO RX_EXIT
KEY146:
    ETX  4800,146
    SPEED 3
    SERVO 16,55
    SPEED 5
    GOTO RX_EXIT
KEY147:
    ETX  4800,147
    SPEED 3
    SERVO 16,54
    GOTO RX_EXIT
KEY148:
    ETX  4800,148
    SPEED 3
    SERVO 16,53
    GOTO RX_EXIT
KEY149:
    ETX  4800,149
    SPEED 3
    SERVO 16,52
    GOTO RX_EXIT
KEY150:
    ETX  4800,150
    SPEED 3
    SERVO 16,51
    GOTO RX_EXIT
KEY151:
    ETX  4800,151
    SPEED 3
    SERVO 16,50
    GOTO RX_EXIT
KEY152:
    ETX  4800,152
    SPEED 3
    SERVO 16,49
    GOTO RX_EXIT
KEY153:
    ETX  4800,153
    SPEED 3
    SERVO 16,48
    GOTO RX_EXIT
KEY154:
    ETX  4800,154
    SPEED 3
    SERVO 16,47
    GOTO RX_EXIT
KEY155:
    ETX  4800,155
    SPEED 3
    SERVO 16,46
    GOTO RX_EXIT
KEY156:
    ETX  4800,156
    SPEED 3
    SERVO 16,45
    GOTO RX_EXIT
KEY157:
    ETX  4800,157
    SPEED 3
    SERVO 16,44
    GOTO RX_EXIT
KEY158:
    ETX  4800,158
    SPEED 3
    SERVO 16,43
    GOTO RX_EXIT
KEY159:
    ETX  4800,159
    SPEED 3
    SERVO 16,42
    GOTO RX_EXIT
KEY160:
    ETX  4800,160
    SPEED 3
    SERVO 16,41
    GOTO RX_EXIT
