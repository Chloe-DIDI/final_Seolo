CREATE OR REPLACE PROCEDURE PRC_CHECKLIST_UPDATE
( V_CHECK_NO    IN CHECKLIST.CHECK_NO%TYPE
--, V_AC_NO       IN CHECKLIST.AC_NO%TYPE           -- ������ȣ�� ���� �Ұ�
, V_RES_NO      IN CHECKLIST.RES_NO%TYPE
, V_CHECKDATE   IN CHECKLIST.CHECKDATE%TYPE
, V_TITLE       IN CHECKLIST.TITLE%TYPE
, V_ROADADDR    IN CHECKLIST.ROADADDR%TYPE
, V_DONG_NO     IN CHECKLIST.DONG_NO%TYPE
, V_WIDO        IN CHECKLIST.WIDO%TYPE
, V_GYEONGDO    IN CHECKLIST.GYEONGDO%TYPE
, V_GOOD        IN CONTENT.GOOD%TYPE                := NULL
, V_BAD         IN CONTENT.BAD%TYPE                 := NULL
, V_ETC         IN CONTENT.ETC%TYPE                 := NULL
, V_S_COMMENTS  IN SECRET_CONTENT.COMMENTS%TYPE     := NULL
, V_MART        IN CONVENIENCE.MART%TYPE            := NULL
, V_LAUNDRY     IN CONVENIENCE.LAUNDRY%TYPE         := NULL
, V_HOSPITAL    IN CONVENIENCE.HOSPITAL%TYPE        := NULL
, V_FOOD        IN CONVENIENCE.FOOD%TYPE            := NULL
, V_CULTURE     IN CONVENIENCE.CULTURE%TYPE         := NULL
, V_PARK        IN CONVENIENCE.PARK%TYPE            := NULL
, V_C_COMMENTS  IN CONVENIENCE.COMMENTS%TYPE        := NULL
, V_MWOLSE      IN WOLSE.MWOLSE%TYPE                := NULL
, V_DEPOSIT     IN WOLSE.DEPOSIT%TYPE               := NULL
, V_MJEONSE     IN JEONSE.MJEONSE%TYPE              := NULL
, V_MMAEMAE     IN MAEMAE.MMAEMAE%TYPE              := NULL
, V_PLACE       IN GOING.PLACE%TYPE                 := NULL
, V_TIME        IN GOING.TIME%TYPE                  := NULL
, V_P_COMMENTS  IN PET.COMMENTS%TYPE                := NULL
, V_P_SCORENO	IN PET.SCORENO%TYPE                 := NULL
, V_SE_COMMENTS IN SECURITY.COMMENTS%TYPE           := NULL
, V_SE_SCORENO  IN SECURITY.SCORENO%TYPE            := NULL
, V_T_COMMENTS  IN TRANSPORT.COMMENTS%TYPE          := NULL
, V_T_SCORENO   IN TRANSPORT.SCORENO%TYPE           := NULL
, V_H_COMMENTS  IN HONJAP.COMMENTS%TYPE             := NULL
, V_H_SCORENO   IN HONJAP.SCORENO%TYPE              := NULL
)

IS
    -- ���� ����
    CON_ALL_OR_NOT_ERROR         EXCEPTION; 
    WOLSE_ALL_OR_NOT_ERROR       EXCEPTION;
    GOING_ALL_OR_NOT_ERROR       EXCEPTION;

BEGIN
    --�� UPDATE
    -- üũ����Ʈ(�ʼ�)
    -- üũ����Ʈ �ʼ��׸��� NOT NULL ���������� �̹� �ɷ�����
    -- �� ����, �Է����� ���� �� ���ܰ� �߻��ϹǷ� ���� ��ȿ�� �˻縦 �������� ����
    UPDATE CHECKLIST
    SET RES_NO=V_RES_NO, CHECKDATE=V_CHECKDATE, TITLE=V_TITLE, ROADADDR=V_ROADADDR
      , DONG_NO=V_DONG_NO, WIDO=V_WIDO, GYEONGDO=V_GYEONGDO
    WHERE CHECK_NO = V_CHECK_NO;

    -- �ڸ�Ʈ
    IF( (V_GOOD IS NOT NULL) OR ( V_BAD IS NOT NULL ) OR ( V_ETC IS NOT NULL) )
        THEN UPDATE CONTENT
             SET GOOD=V_GOOD, BAD=V_BAD, ETC=V_ETC
             WHERE CHECK_NO = V_CHECK_NO;
    END IF;
        
    -- ����ڸ�Ʈ
    IF(V_S_COMMENTS IS NOT NULL)
        THEN UPDATE SECRET_CONTENT
             SET COMMENTS = V_S_COMMENTS
             WHERE CHECK_NO = V_CHECK_NO;
    END IF;

    -- ��Ȱ���ǽü�
    -- 6���� �׸��� ���� �ԷµǾ����� �� INSERT 
    --              ��(��� �Էµ� �� �ƴѵ�) �ϳ��� �ԷµǾ� ������ �� ���� �߻�
    IF( (V_MART IS NOT NULL) AND (V_LAUNDRY IS NOT NULL) AND (V_HOSPITAL IS NOT NULL)
            AND (V_FOOD IS NOT NULL) AND (V_CULTURE IS NOT NULL) AND (V_PARK IS NOT NULL) )
        THEN UPDATE CONVENIENCE
             SET MART=V_MART, LAUNDRY=V_LAUNDRY, HOSPITAL=V_HOSPITAL, FOOD=V_FOOD
               , CULTURE=V_CULTURE, PARK=V_PARK, COMMENTS=V_C_COMMENTS
             WHERE CHECK_NO = V_CHECK_NO;
    ELSIF ( (V_MART IS NOT NULL) OR (V_LAUNDRY IS NOT NULL) OR (V_HOSPITAL IS NOT NULL)
            OR (V_FOOD IS NOT NULL) OR (V_CULTURE IS NOT NULL) OR (V_PARK IS NOT NULL) )
        THEN RAISE CON_ALL_OR_NOT_ERROR;
    END IF;

    -- ����
    -- 2���� �׸��� ���� �ԷµǾ����� �� INSERT 
    --              ��(��� �Էµ� �� �ƴѵ�) �ϳ��� �ԷµǾ� ������ �� ���� �߻�
    IF( (V_MWOLSE IS NOT NULL) AND (V_DEPOSIT IS NOT NULL) )
        THEN UPDATE WOLSE
             SET MWOLSE=V_MWOLSE, DEPOSIT=V_DEPOSIT
             WHERE CHECK_NO = V_CHECK_NO;
    ELSIF ( (V_MWOLSE IS NOT NULL) OR (V_DEPOSIT IS NOT NULL) )
        THEN RAISE WOLSE_ALL_OR_NOT_ERROR;
    END IF;

    -- ����
    IF(V_MJEONSE IS NOT NULL)
        THEN UPDATE JEONSE
             SET MJEONSE = V_MJEONSE
             WHERE CHECK_NO = V_CHECK_NO;
    END IF;

    -- �Ÿ�
    IF(V_MMAEMAE IS NOT NULL)
        THEN UPDATE MAEMAE
             SET MMAEMAE = V_MMAEMAE
             WHERE CHECK_NO = V_CHECK_NO;
    END IF;    

    -- ���� ��ٽð�
    -- 2���� �׸��� ���� �ԷµǾ����� �� INSERT 
    --              ��(��� �Էµ� �� �ƴѵ�) �ϳ��� �ԷµǾ� ������ �� ���� �߻�
    IF( (V_PLACE IS NOT NULL) AND (V_TIME IS NOT NULL) )
        THEN UPDATE GOING
             SET PLACE=V_PLACE, TIME=V_TIME
             WHERE CHECK_NO = V_CHECK_NO;
    ELSIF( (V_PLACE IS NOT NULL) OR (V_TIME IS NOT NULL) )
        THEN RAISE GOING_ALL_OR_NOT_ERROR;
    END IF;

    -- �ݷ�����
    IF(V_P_SCORENO IS NOT NULL)
        THEN UPDATE PET
             SET COMMENTS=V_P_COMMENTS, SCORENO=V_P_SCORENO
             WHERE CHECK_NO = V_CHECK_NO;
    END IF;    

    -- ġ��
    IF(V_SE_SCORENO IS NOT NULL)
        THEN UPDATE SECURITY
             SET COMMENTS=V_SE_COMMENTS, SCORENO=V_SE_SCORENO
             WHERE CHECK_NO = V_CHECK_NO;
    END IF;    

    -- ���߱���
    IF(V_T_SCORENO IS NOT NULL)
        THEN UPDATE TRANSPORT
             SET COMMENTS=V_T_COMMENTS, SCORENO=V_T_SCORENO
             WHERE CHECK_NO = V_CHECK_NO;
    END IF; 

    -- ����ȥ�⵵
    IF(V_H_SCORENO IS NOT NULL)
        THEN UPDATE HONJAP
             SET COMMENTS=V_H_COMMENTS, SCORENO=V_H_SCORENO
             WHERE CHECK_NO = V_CHECK_NO;
    END IF;


    --�� Ŀ��
    COMMIT;
    

    --�� ����ó��
    EXCEPTION
        WHEN CON_ALL_OR_NOT_ERROR
             THEN RAISE_APPLICATION_ERROR(-20004, '��Ȱ���ǽü��� ���� ������ ��� �Է��ϰų� �Է����� �ʾƾ� �մϴ�.');
                  ROLLBACK;
        WHEN WOLSE_ALL_OR_NOT_ERROR
             THEN RAISE_APPLICATION_ERROR(-20005, '������ ���� ������ ��� �Է��ϰų� �Է����� �ʾƾ� �մϴ�.');
                  ROLLBACK;
        WHEN GOING_ALL_OR_NOT_ERROR
             THEN RAISE_APPLICATION_ERROR(-20006, '���� ��ٽð��� ���� ������ ��� �Է��ϰų� �Է����� �ʾƾ� �մϴ�.');
                  ROLLBACK;

        WHEN OTHERS THEN ROLLBACK;

END;