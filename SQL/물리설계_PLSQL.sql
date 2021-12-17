-- �������� PL/SQL
SELECT USER FROM DUAL;

------------------------------------------------------------------------------------
--�� ����(���� ����/����)
--�� ���� ���� ���ν��� (����, �������� ���̺� �־��ش�.)
--> ������ ������ �Ǹ� �������̺� �����������̺� �� �� �Է�

CREATE OR REPLACE PROCEDURE PRC_ACCOUNT_CREATE
( 
    V_PE_ID         IN PERSONAL.PE_ID%TYPE
,	V_NAME          IN PERSONAL.NAME%TYPE
,	V_TEL           IN PERSONAL.TEL%TYPE
,	V_NICKNAME      IN PERSONAL.NICKNAME%TYPE
,	V_PW            IN PERSONAL.PW%TYPE
,	V_EMAIL         IN PERSONAL.EMAIL%TYPE
,	V_ROADADDR      IN PERSONAL.ROADADDR%TYPE
,	V_DETAILADDR    IN PERSONAL.DETAILADDR%TYPE
)
IS  
    -- ���� ����
    V_AC_NO         NUMBER;
    
BEGIN
    -- ���� �ڵ� �ڵ����� ���� ��ȸ
    SELECT NVL(MAX(AC_NO),0) INTO V_AC_NO
    FROM ACCOUNT;

    -- �������� ���̺� INSERT
    INSERT INTO ACCOUNT(AC_NO) VALUES(V_AC_NO+1);
    
    -- ���� ���̺� INSERT ******
    INSERT INTO PERSONAL(AC_NO, PE_ID, NAME, TEL, NICKNAME, PW, EMAIL, ROADADDR, DETAILADDR, PROFILE, PEDATE)
        VALUES(V_AC_NO+1, V_PE_ID, V_NAME, V_TEL, V_NICKNAME, V_PW, V_EMAIL, V_ROADADDR, V_DETAILADDR, NULL, SYSDATE);

    -- ����ó��
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK;
END;


EXEC PRC_ACCOUNT_CREATE('test001', '�׽�Ʈ', '010-1122-2233', 'tesstt','java006$','test001@test.com','����� ������ ������ 247-86','1��','001.jpg',TO_DATE('2021-06-01', 'YYYY-MM-DD'));
EXEC PRC_ACCOUNT_CREATE('test002', '�׽�Ʈ2', '010-2233-4455', 'tesst22222t','java006$','test002@test.com','����� ������ ������ 247-86','3��','003.jpg',TO_DATE('2021-06-10', 'YYYY-MM-DD'));



--��  ���� ���� ���ν��� (�������� ���̺��� ���ְ�, Ż��ȸ�� ���̺� ����)
--> ������ �����ϸ� �������� ���̺��� -, Ż��ȸ�� ���̺� +

-- ���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_ACCOUNT_DELETE
-- �Ű����� : �Է¹��� �ֵ� - Ż��ȸ�� ���̺�� ���°�
-- ���̵�� ��ȭ��ȣ�� �Է��Ͽ� Ȯ�� �� ��ġ�ϸ� Ż�� �Ϸ� ~!
(
    V_WIR_NO        IN WITHDRAWAL.WIR_NO%TYPE
,	V_COMMENTS    	IN WITHDRAWAL.COMMENTS%TYPE
,	V_WIDATE      	IN WITHDRAWAL.WIDATE%TYPE
,	V_ID           	IN WITHDRAWAL.ID%TYPE
,	V_NAME         	IN WITHDRAWAL.NAME%TYPE
,	V_TEL      		IN WITHDRAWAL.TEL%TYPE

)
IS
    -- ���� ����
    V_AC_NO         NUMBER;
    V_WI_NO         NUMBER;

    
    -- ����� �� �ʿ��� ��
    -- EXCEPTION
    -- �ߺ� �ȵǰ� �ؾߵǴ� �� -> ���̵�, ��й�ȣ
    TEMP_ID     NUMBER;
    TEMP_TEL    NUMBER;
    
    ID_DELETE_ERROR    EXCEPTION;  -- ���̵� �ٸ� ��
    TEL_DELETE_ERROR   EXCEPTION;  -- ��ȭ��ȣ�� �ٸ� ��
    
BEGIN

    -- Ż�� ������ȣ �ڵ����� ���� ��ȸ
    SELECT NVL(MAX(WI_NO),0) INTO V_WI_NO
    FROM WITHDRAWAL;

    -- TEMP�� ���İ��°ǵ� 0�̶� 1�� �޾Ƽ�
    -- ���� ���� Ȯ��
    -- �ؿ� COUNT(*)�̰� 0�̳� 1
    -- �ߺ� ���̵�
    SELECT COUNT(*) INTO TEMP_ID
    FROM PERSONAL
    WHERE PE_ID = V_ID;
    IF (TEMP_ID = 0)                    -- 0 �̸� ���̵� �����ϱ� ���� ���� ~!
        THEN RAISE ID_DELETE_ERROR;
    END IF;
    -- �ߺ� ��ȭ��ȣ
    SELECT COUNT(*) INTO TEMP_TEL
    FROM PERSONAL
    WHERE TEL = V_TEL;
    IF (TEMP_TEL = 0)                   -- 0 �̸� ��ȭ��ȣ�� �����ϱ� ���� ���� ~!
        THEN RAISE TEL_DELETE_ERROR;
    END IF;
  
    -- V_AC_NO�� ���� �־��ֱ� -- ����� ���̵�� �׻����  AC_NO�� �˼������ϱ� �̰Ÿ� V_AC_NO�� ����
    SELECT AC_NO
        INTO V_AC_NO
        FROM PERSONAL
    WHERE PE_ID = V_ID;
    
    
    -- Ż��ȸ�� ���̺� +       
    INSERT INTO WITHDRAWAL(WI_NO, AC_NO, WIR_NO, COMMENTS, WIDATE, ID, NAME, TEL)
        VALUES (V_WI_NO+1, V_AC_NO, V_WIR_NO, V_COMMENTS, V_WIDATE, V_ID, V_NAME, V_TEL);
    
      
    -- �������� ���̺� -
    DELETE
    FROM PERSONAL
    WHERE PE_ID=V_ID;
      

    -- ����ó��
    -- ���̵�, ��ȭ��ȣ
    EXCEPTION
        WHEN ID_DELETE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20004,'�������� ���� ID �Դϴ�.');
        ROLLBACK;
        WHEN TEL_DELETE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20005,'�������� �ʴ� ��ȭ��ȣ �Դϴ�.');
        ROLLBACK;
      
        WHEN OTHERS THEN ROLLBACK;
END;

--==>> Procedure PRC_ACCOUNT_DELETE��(��) �����ϵǾ����ϴ�.

EXEC PRC_ACCOUNT_DELETE(5, '������ �ٽ� �����Ҳ���.', TO_DATE(SYSDATE, 'YYYY-MM-DD'), 'test002', '�׽�Ʈ2', '010-2233-4455');


COMMIT;
--==>> Ŀ�� �Ϸ�~!


-----------------------------------------------------------------------------------
-- �� �ҿ�
-- Ż��ȸ�� 6����
CREATE OR REPLACE PROCEDURE PROC_WITHDRAWAL_DELETE
IS
BEGIN
    DELETE
    FROM WITHDRAWAL
    WHERE WIDATE < SYSDATE-183;
END;

COMMIT;

SELECT * FROM USER_JOBS;
/*
OWNER	                TEAM_SEOLO
JOB_NAME	                JOB_WITHDRAWAL_DELETE
JOB_CLASS	            DEFAULT_JOB_CLASS
COMMENTS	JOB_            WITHDRAWAL_DELETE
ENABLED	                TRUE
CREDENTIAL_NAME	
DESTINATION	
PROGRAM_NAME	            PRGM_WITHDRAWAL_DELETE
JOB_TYPE	
JOB_ACTION	
NUMBER_OF_ARGUMENTS	
SCHEDULE_OWNER	        TEAM_SEOLO
SCHEDULE_NAME	        SCH_WITHDRAWAL_DELETE
SCHEDULE_TYPE	        NAMED
START_DATE	            21/12/14 12:00:00.400000000 ASIA/SEOUL
REPEAT_INTERVAL	
END_DATE	
EVENT_QUEUE_OWNER	
EVENT_QUEUE_NAME	
EVENT_QUEUE_AGENT	
EVENT_CONDITION	
FILE_WATCHER_OWNER	
FILE_WATCHER_NAME	
*/


-- ������� ��� �Լ� (���� ������ȣ�� ������ ������� RETURN)
-- ����(1) - �۹�ȣ �ۼ���(CHECK_NO)�� ���
-- �����Ű�(3) - �Ű�� �ۼ���(AC_NO)�� ���
CREATE OR REPLACE FUNCTION WARNING_COUNT(V_AC_NO NUMBER)
RETURN NUMBER
    IS
        TEMP_NUM    NUMBER;
        CNTRESULT   NUMBER;
    BEGIN
        SELECT COUNT(*) INTO CNTRESULT
        FROM REPORT_CHECK 
        WHERE STATUS_NO=3 AND AC_NO=V_AC_NO;
        
        SELECT COUNT(*) INTO TEMP_NUM
        FROM
        (
            SELECT R.CHECK_NO, R.STATUS_NO, C.AC_NO
            FROM REPORT_CHECK R, CHECKLIST C
            WHERE R.CHECK_NO=C.CHECK_NO(+)
        )
        WHERE STATUS_NO=1 AND AC_NO=V_AC_NO;
        
        CNTRESULT := CNTRESULT + TEMP_NUM;
    
    RETURN CNTRESULT;
END;
--==> Function WARNING_COUNT��(��) �����ϵǾ����ϴ�.

SELECT * FROM ACCOUNT;
SELECT * FROM PERSONAL;

-------------------------------------------------------------------------------

-- Ż�� ���ν��� ����
--��  ���� ���� ���ν��� (�������� ���̺��� ���ְ�, Ż��ȸ�� ���̺� ����)
--> ������ �����ϸ� �������� ���̺��� -, Ż��ȸ�� ���̺� +

-- ���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_ACCOUNT_DELETE
(   V_AC_NO         IN WITHDRAWAL.AC_NO%TYPE
,   V_WIR_NO        IN WITHDRAWAL.WIR_NO%TYPE
,   V_COMMENTS    	IN WITHDRAWAL.COMMENTS%TYPE
)
IS
    -- ���� ����
    V_WI_NO         NUMBER;
    
    -- ����� �� �ʿ��� ��
    -- EXCEPTION
    -- �ߺ� �ȵǰ� �ؾߵǴ� �� -> ���̵�, ��й�ȣ
    TEMP_ID     VARCHAR2(30);
    TEMP_NAME   VARCHAR2(30);
    TEMP_TEL    VARCHAR2(30);
    
BEGIN
    -- AC_NO�� ���� ���̵� ���� ���
    SELECT PE_ID INTO TEMP_ID
    FROM PERSONAL
    WHERE AC_NO=V_AC_NO;
    
    -- ��ȭ��ȣ ���
    SELECT TEL INTO TEMP_TEL
    FROM PERSONAL
    WHERE AC_NO=V_AC_NO;
  
    -- �̸� ���
    SELECT NAME INTO TEMP_NAME 
    FROM PERSONAL
    WHERE AC_NO=V_AC_NO;
    
    -- Ż��ȸ�� ���̺� +       
    INSERT INTO WITHDRAWAL(WI_NO, AC_NO, WIR_NO, COMMENTS, WIDATE, ID, NAME, TEL)
        VALUES (WITHDRAWALSEQ.NEXTVAL, V_AC_NO, V_WIR_NO, V_COMMENTS, SYSDATE, TEMP_ID, TEMP_NAME, TEMP_TEL);
    
    -- �������� ���̺� -
    DELETE
    FROM PERSONAL
    WHERE AC_NO=V_AC_NO;
      

    -- ����ó��
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK;
END;
--==>> Procedure PRC_ACCOUNT_DELETE��(��) �����ϵǾ����ϴ�.

COMMIT;