-- DDL gerado pelo Data Modeler

-- Gerado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   em:        2026-05-21 15:00:30 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE TB_ALERT 
    ( 
     alert_id      INTEGER  NOT NULL , 
     type          VARCHAR2 (15)  NOT NULL , 
     message       VARCHAR2 (200)  NOT NULL , 
     alert_level   VARCHAR2 (10)  NOT NULL , 
     created_at    TIMESTAMP WITH LOCAL TIME ZONE  NOT NULL , 
     TB_PET_pet_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE TB_ALERT 
    ADD 
    CHECK (type IN ('ACTIVITY', 'TEMPERATURE')) 
;

ALTER TABLE TB_ALERT 
    ADD 
    CHECK (alert_level IN ('CRITICAL', 'INFO', 'WARNING')) 
;

ALTER TABLE TB_ALERT 
    ADD CONSTRAINT TB_ALERT_PK PRIMARY KEY ( alert_id ) ;

CREATE TABLE TB_AUTH 
    ( 
     refresh_token   VARCHAR2 (255)  NOT NULL , 
     expires_at      TIMESTAMP WITH LOCAL TIME ZONE  NOT NULL , 
     TB_USER_user_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE TB_AUTH 
    ADD CONSTRAINT TB_AUTH_PK PRIMARY KEY ( refresh_token ) ;

CREATE TABLE TB_DEVICE 
    ( 
     device_id      INTEGER  NOT NULL , 
     device_status  CHAR (1)  NOT NULL , 
     device_battery NUMBER (3)  NOT NULL , 
     last_seen      TIMESTAMP WITH LOCAL TIME ZONE  NOT NULL , 
     TB_PET_pet_id  INTEGER  NOT NULL 
    ) 
;
CREATE UNIQUE INDEX TB_DEVICE__IDX ON TB_DEVICE 
    ( 
     TB_PET_pet_id ASC 
    ) 
;

ALTER TABLE TB_DEVICE 
    ADD CONSTRAINT TB_DEVICE_PK PRIMARY KEY ( device_id ) ;

CREATE TABLE TB_PET 
    ( 
     pet_id          INTEGER  NOT NULL , 
     pet_name        VARCHAR2 (255)  NOT NULL , 
     age             INTEGER  NOT NULL , 
     weight          NUMBER (5,3)  NOT NULL , 
     breed           VARCHAR2 (60)  NOT NULL , 
     created_at      TIMESTAMP WITH LOCAL TIME ZONE  NOT NULL , 
     TB_USER_user_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE TB_PET 
    ADD CONSTRAINT TB_PET_PK PRIMARY KEY ( pet_id ) ;

CREATE TABLE TB_SENSOR_DATA 
    ( 
     sensor_id           INTEGER  NOT NULL , 
     timestamp           TIMESTAMP WITH LOCAL TIME ZONE  NOT NULL , 
     temperature         NUMBER (3,1)  NOT NULL , 
     heart_rate          NUMBER (3)  NOT NULL , 
     activity_level      VARCHAR2 (20)  NOT NULL , 
     latitude            NUMBER (9,7)  NOT NULL , 
     longitude           NUMBER (10,7)  NOT NULL , 
     sensor_battery      NUMBER (3)  NOT NULL , 
     sensor_status       CHAR (1)  NOT NULL , 
     TB_DEVICE_device_id INTEGER  NOT NULL 
    ) 
;

ALTER TABLE TB_SENSOR_DATA 
    ADD 
    CHECK (activity_level IN ('HIGH', 'LOW', 'MEDIUM')) 
;

ALTER TABLE TB_SENSOR_DATA 
    ADD CONSTRAINT TB_SENSOR_DATA_PK PRIMARY KEY ( sensor_id ) ;

CREATE TABLE TB_USER 
    ( 
     user_id       INTEGER  NOT NULL , 
     user_name     VARCHAR2 (255)  NOT NULL , 
     email         VARCHAR2 (255)  NOT NULL , 
     password_hash VARCHAR2 (60)  NOT NULL , 
     created_at    TIMESTAMP WITH LOCAL TIME ZONE  NOT NULL 
    ) 
;

ALTER TABLE TB_USER 
    ADD CONSTRAINT TB_USER_PK PRIMARY KEY ( user_id ) ;

ALTER TABLE TB_USER 
    ADD CONSTRAINT TB_USER_EMAIL_UN UNIQUE ( email ) ;

ALTER TABLE TB_ALERT 
    ADD CONSTRAINT TB_ALERT_TB_PET_FK FOREIGN KEY 
    ( 
     TB_PET_pet_id
    ) 
    REFERENCES TB_PET 
    ( 
     pet_id
    ) 
;

ALTER TABLE TB_AUTH 
    ADD CONSTRAINT TB_AUTH_TB_USER_FK FOREIGN KEY 
    ( 
     TB_USER_user_id
    ) 
    REFERENCES TB_USER 
    ( 
     user_id
    ) 
;

ALTER TABLE TB_DEVICE 
    ADD CONSTRAINT TB_DEVICE_TB_PET_FK FOREIGN KEY 
    ( 
     TB_PET_pet_id
    ) 
    REFERENCES TB_PET 
    ( 
     pet_id
    ) 
;

ALTER TABLE TB_PET 
    ADD CONSTRAINT TB_PET_TB_USER_FK FOREIGN KEY 
    ( 
     TB_USER_user_id
    ) 
    REFERENCES TB_USER 
    ( 
     user_id
    ) 
;

ALTER TABLE TB_SENSOR_DATA 
    ADD CONSTRAINT TB_SENSOR_DATA_TB_DEVICE_FK FOREIGN KEY 
    ( 
     TB_DEVICE_device_id
    ) 
    REFERENCES TB_DEVICE 
    ( 
     device_id
    ) 
;

-- Relatório do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             6
-- CREATE INDEX                             1
-- ALTER TABLE                             15
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

-- Criação da tabela de Logs solicitada
CREATE TABLE TB_LOG_ERRO (
    log_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    procedure_name VARCHAR2(100),
    user_name VARCHAR2(100),
    error_date TIMESTAMP,
    error_code NUMBER,
    error_message VARCHAR2(4000)
);

set verify off;
set serveroutput on;

-- Criação das Procedures (1 por tabela)

CREATE OR REPLACE PROCEDURE PRC_CARGA_TB_USER (
    p_user_id       IN TB_USER.user_id%TYPE,
    p_user_name     IN TB_USER.user_name%TYPE,
    p_email         IN TB_USER.email%TYPE,
    p_password_hash IN TB_USER.password_hash%TYPE,
    p_created_at    IN TB_USER.created_at%TYPE
)
IS
    v_email_existe NUMBER;
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    SELECT COUNT(email)
    INTO v_email_existe
    FROM TB_USER
    WHERE email = p_email;
    
    IF v_email_existe > 0 THEN
        RAISE DUP_VAL_ON_INDEX;
    ELSE
        INSERT INTO TB_USER (
            user_id,
            user_name,
            email,
            password_hash,
            created_at
        )VALUES (
            p_user_id,
            p_user_name,
            p_email,
            p_password_hash,
            p_created_at
        );
        DBMS_OUTPUT.PUT_LINE('Usuário cadastrado com sucesso.');
        COMMIT;
    END IF;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        v_error_code := SQLCODE;
        v_error_message := 'E-mail duplicado';
        DBMS_OUTPUT.PUT_LINE('Erro: e-mail já cadastrado.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )VALUES (
            'PRC_CARGA_TB_USER',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
    WHEN VALUE_ERROR THEN
        v_error_code := SQLCODE;
        v_error_message := 'Erro de valor';
        DBMS_OUTPUT.PUT_LINE('Erro de valor.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )VALUES (
            'PRC_CARGA_TB_USER',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
    WHEN OTHERS THEN
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )
        VALUES (
            'PRC_CARGA_TB_USER',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
END;

CREATE OR REPLACE PROCEDURE PRC_CARGA_TB_PET (
    p_pet_id          IN TB_PET.pet_id%TYPE,
    p_pet_name        IN TB_PET.pet_name%TYPE,
    p_age             IN TB_PET.age%TYPE,
    p_weight          IN TB_PET.weight%TYPE,
    p_breed           IN TB_PET.breed%TYPE,
    p_created_at      IN TB_PET.created_at%TYPE,
    p_tb_user_user_id IN TB_PET.tb_user_user_id%TYPE
)
IS

    v_user_existe NUMBER;

    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);

BEGIN
    SELECT COUNT(user_id)
    INTO v_user_existe
    FROM TB_USER
    WHERE user_id = p_tb_user_user_id;
    IF v_user_existe = 0 THEN
        RAISE VALUE_ERROR;
    ELSE
        INSERT INTO TB_PET (
            pet_id,
            pet_name,
            age,
            weight,
            breed,
            created_at,
            tb_user_user_id
        )
        VALUES (
            p_pet_id,
            p_pet_name,
            p_age,
            p_weight,
            p_breed,
            p_created_at,
            p_tb_user_user_id
        );
        DBMS_OUTPUT.PUT_LINE('Pet cadastrado com sucesso.');
        COMMIT;
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        v_error_code := SQLCODE;
        v_error_message := 'Pet já cadastrado';
        DBMS_OUTPUT.PUT_LINE('Erro: pet já cadastrado.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )
        VALUES (
            'PRC_CARGA_TB_PET',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
    WHEN VALUE_ERROR THEN
        v_error_code := SQLCODE;
        v_error_message := 'Usuário não encontrado';
        DBMS_OUTPUT.PUT_LINE('Erro: usuário não encontrado.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )
        VALUES (
            'PRC_CARGA_TB_PET',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
    WHEN OTHERS THEN
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )
        VALUES (
            'PRC_CARGA_TB_PET',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
END;

CREATE OR REPLACE PROCEDURE PRC_CARGA_TB_DEVICE (
    p_device_id       IN TB_DEVICE.device_id%TYPE,
    p_device_status   IN TB_DEVICE.device_status%TYPE,
    p_device_battery  IN TB_DEVICE.device_battery%TYPE,
    p_last_seen       IN TB_DEVICE.last_seen%TYPE,
    p_tb_pet_pet_id   IN TB_DEVICE.tb_pet_pet_id%TYPE
)
IS
    v_pet_existe NUMBER;
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    SELECT COUNT(pet_id)
    INTO v_pet_existe
    FROM TB_PET
    WHERE pet_id = p_tb_pet_pet_id;
    IF v_pet_existe = 0 THEN
        RAISE VALUE_ERROR;
    ELSE
        INSERT INTO TB_DEVICE (
            device_id,
            device_status,
            device_battery,
            last_seen,
            tb_pet_pet_id
        )
        VALUES (
            p_device_id,
            p_device_status,
            p_device_battery,
            p_last_seen,
            p_tb_pet_pet_id
        );
        DBMS_OUTPUT.PUT_LINE('Device cadastrado com sucesso.');
        COMMIT;
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        v_error_code := SQLCODE;
        v_error_message := 'Device já cadastrado';
        DBMS_OUTPUT.PUT_LINE('Erro: device já cadastrado.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )
        VALUES (
            'PRC_CARGA_TB_DEVICE',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
    WHEN VALUE_ERROR THEN
        v_error_code := SQLCODE;
        v_error_message := 'Pet não encontrado';
        DBMS_OUTPUT.PUT_LINE('Erro: pet não encontrado.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )
        VALUES (
            'PRC_CARGA_TB_DEVICE',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
    WHEN OTHERS THEN
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )
        VALUES (
            'PRC_CARGA_TB_DEVICE',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
END;

CREATE OR REPLACE PROCEDURE PRC_CARGA_TB_SENSOR_DATA (
    p_sensor_id           IN TB_SENSOR_DATA.sensor_id%TYPE,
    p_timestamp           IN TB_SENSOR_DATA.timestamp%TYPE,
    p_temperature         IN TB_SENSOR_DATA.temperature%TYPE,
    p_heart_rate          IN TB_SENSOR_DATA.heart_rate%TYPE,
    p_activity_level      IN TB_SENSOR_DATA.activity_level%TYPE,
    p_latitude            IN TB_SENSOR_DATA.latitude%TYPE,
    p_longitude           IN TB_SENSOR_DATA.longitude%TYPE,
    p_sensor_battery      IN TB_SENSOR_DATA.sensor_battery%TYPE,
    p_sensor_status       IN TB_SENSOR_DATA.sensor_status%TYPE,
    p_tb_device_device_id IN TB_SENSOR_DATA.tb_device_device_id%TYPE
)
IS
    v_device_existe NUMBER;
    v_error_code NUMBER;
    v_error_message VARCHAR2(4000);
BEGIN
    SELECT COUNT(device_id)
    INTO v_device_existe
    FROM TB_DEVICE
    WHERE device_id = p_tb_device_device_id;
    IF v_device_existe = 0 THEN
        RAISE VALUE_ERROR;
    ELSE
        INSERT INTO TB_SENSOR_DATA (
            sensor_id,
            timestamp,
            temperature,
            heart_rate,
            activity_level,
            latitude,
            longitude,
            sensor_battery,
            sensor_status,
            tb_device_device_id
        )
        VALUES (
            p_sensor_id,
            p_timestamp,
            p_temperature,
            p_heart_rate,
            p_activity_level,
            p_latitude,
            p_longitude,
            p_sensor_battery,
            p_sensor_status,
            p_tb_device_device_id
        );
        DBMS_OUTPUT.PUT_LINE('Dados do sensor cadastrados com sucesso.');
        COMMIT;
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        v_error_code := SQLCODE;
        v_error_message := 'Sensor já cadastrado';
        DBMS_OUTPUT.PUT_LINE('Erro: sensor já cadastrado.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )
        VALUES (
            'PRC_CARGA_TB_SENSOR_DATA',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
    WHEN VALUE_ERROR THEN
        v_error_code := SQLCODE;
        v_error_message := 'Device não encontrado';
        DBMS_OUTPUT.PUT_LINE('Erro: device não encontrado.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )
        VALUES (
            'PRC_CARGA_TB_SENSOR_DATA',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
    WHEN OTHERS THEN
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('Erro inesperado.');
        INSERT INTO TB_LOG_ERRO (
            procedure_name,
            user_name,
            error_date,
            error_code,
            error_message
        )
        VALUES (
            'PRC_CARGA_TB_SENSOR_DATA',
            SYS_CONTEXT('USERENV', 'SESSION_USER'),
            SYSTIMESTAMP,
            v_error_code,
            v_error_message
        );
END;

CREATE OR REPLACE PROCEDURE PRC_CARGA_TB_ALERT (
    p_alert_id       IN TB_ALERT.alert_id%TYPE,
    p_type           IN TB_ALERT.type%TYPE,
    p_message        IN TB_ALERT.message%TYPE,
    p_alert_level    IN TB_ALERT.alert_level%TYPE,
    p_created_at     IN TB_ALERT.created_at%TYPE,
    p_tb_pet_pet_id  IN TB_ALERT.tb_pet_pet_id%TYPE
)
IS
BEGIN
    INSERT INTO TB_ALERT (
        alert_id,
        type,
        message,
        alert_level,
        created_at,
        tb_pet_pet_id
    )
    VALUES (
        p_alert_id,
        p_type,
        p_message,
        p_alert_level,
        p_created_at,
        p_tb_pet_pet_id
    );
    DBMS_OUTPUT.PUT_LINE('Alerta cadastrado com sucesso.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar alerta.');
END;

CREATE OR REPLACE PROCEDURE PRC_CARGA_TB_AUTH (
    p_refresh_token   IN TB_AUTH.refresh_token%TYPE,
    p_expires_at      IN TB_AUTH.expires_at%TYPE,
    p_tb_user_user_id IN TB_AUTH.tb_user_user_id%TYPE
)
IS
BEGIN
    INSERT INTO TB_AUTH (
        refresh_token,
        expires_at,
        tb_user_user_id
    )
    VALUES (
        p_refresh_token,
        p_expires_at,
        p_tb_user_user_id
    );
    DBMS_OUTPUT.PUT_LINE('Autenticação cadastrada com sucesso.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar autenticação.');
END;

-- Iniciando carga de dados
BEGIN
    PRC_CARGA_TB_USER(
        1,
        'Jose',
        'jose@email.com',
        '123456',
        SYSTIMESTAMP
    );
    PRC_CARGA_TB_USER(
        2,
        'Gabriel',
        'gabriel@email.com',
        '123456',
        SYSTIMESTAMP
    );
    PRC_CARGA_TB_USER(
        3,
        'Arthur',
        'arthur@email.com',
        '123456',
        SYSTIMESTAMP
    );
    PRC_CARGA_TB_USER(
        4,
        'Rafael',
        'rafael@email.com',
        '123456',
        SYSTIMESTAMP
    );
    PRC_CARGA_TB_USER(
        5,
        'Rafael Pascotte',
        'rafaelpascotte@email.com',
        '123456',
        SYSTIMESTAMP
    );
END;

BEGIN
    PRC_CARGA_TB_PET(
        1,
        'Thor',
        5,
        12.5,
        'Golden Retriever',
        SYSTIMESTAMP,
        1
    );
    PRC_CARGA_TB_PET(
        2,
        'Pingo',
        6,
        2.5,
        'Yorkshire',
        SYSTIMESTAMP,
        2
    );
    PRC_CARGA_TB_PET(
        3,
        'Cookie',
        4,
        22.5,
        'Pitbull',
        SYSTIMESTAMP,
        3
    );
    PRC_CARGA_TB_PET(
        4,
        'Mel',
        2,
        6.8,
        'Shih Tzu',
        SYSTIMESTAMP,
        4
    );
    PRC_CARGA_TB_PET(
        5,
        'Bob',
        6,
        15.1,
        'Labrador',
        SYSTIMESTAMP,
        5
    );
END;

BEGIN
    PRC_CARGA_TB_DEVICE(
        1,
        'A',
        90,
        SYSTIMESTAMP,
        1
    );
    PRC_CARGA_TB_DEVICE(
        2,
        'A',
        85,
        SYSTIMESTAMP,
        2
    );
    PRC_CARGA_TB_DEVICE(
        3,
        'A',
        88,
        SYSTIMESTAMP,
        3
    );
    PRC_CARGA_TB_DEVICE(
        4,
        'A',
        76,
        SYSTIMESTAMP,
        4
    );
    PRC_CARGA_TB_DEVICE(
        5,
        'A',
        82,
        SYSTIMESTAMP,
        5
    );
END;

BEGIN
    PRC_CARGA_TB_SENSOR_DATA(
        1,
        SYSTIMESTAMP,
        38.5,
        120,
        'HIGH',
        -23.550520,
        -46.633308,
        80,
        'A',
        1
    );
    PRC_CARGA_TB_SENSOR_DATA(
        2,
        SYSTIMESTAMP,
        37.9,
        95,
        'MEDIUM',
        -23.551000,
        -46.632000,
        78,
        'A',
        2
    );
    PRC_CARGA_TB_SENSOR_DATA(
        3,
        SYSTIMESTAMP,
        39.1,
        130,
        'HIGH',
        -23.561684,
        -46.625378,
        75,
        'A',
        3
    );
    PRC_CARGA_TB_SENSOR_DATA(
        4,
        SYSTIMESTAMP,
        36.8,
        88,
        'LOW',
        -23.563210,
        -46.654321,
        70,
        'A',
        4
    );
    PRC_CARGA_TB_SENSOR_DATA(
        5,
        SYSTIMESTAMP,
        39.4,
        140,
        'HIGH',
        -23.570000,
        -46.620000,
        68,
        'A',
        5
    );
END;

BEGIN
    PRC_CARGA_TB_ALERT(
        1,
        'TEMPERATURE',
        'Temperatura elevada detectada',
        'WARNING',
        SYSTIMESTAMP,
        1
    );
    PRC_CARGA_TB_ALERT(
        2,
        'ACTIVITY',
        'Atividade intensa detectada',
        'INFO',
        SYSTIMESTAMP,
        2
    );
    PRC_CARGA_TB_ALERT(
        3,
        'TEMPERATURE',
        'Temperatura crítica detectada',
        'CRITICAL',
        SYSTIMESTAMP,
        3
    );
    PRC_CARGA_TB_ALERT(
        4,
        'ACTIVITY',
        'Baixa atividade detectada',
        'WARNING',
        SYSTIMESTAMP,
        4
    );
    PRC_CARGA_TB_ALERT(
        5,
        'TEMPERATURE',
        'Temperatura normalizada',
        'INFO',
        SYSTIMESTAMP,
        5
    );
END;

BEGIN
    PRC_CARGA_TB_AUTH(
        'token123',
        SYSTIMESTAMP,
        1
    );
    PRC_CARGA_TB_AUTH(
        'token456',
        SYSTIMESTAMP,
        2
    );
    PRC_CARGA_TB_AUTH(
        'token789',
        SYSTIMESTAMP,
        3
    );
    PRC_CARGA_TB_AUTH(
        'token101',
        SYSTIMESTAMP,
        4
    );
    PRC_CARGA_TB_AUTH(
        'token202',
        SYSTIMESTAMP,
        5
    );
END;

-- Consultas para mostrar os dados inseridos
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('===== CONSULTA 1 =====');
    FOR dados IN (
        SELECT 
            u.user_name,
            p.pet_name,
            d.device_status,
            d.device_battery
        FROM TB_USER u
        INNER JOIN TB_PET p
            ON u.user_id = p.tb_user_user_id
        INNER JOIN TB_DEVICE d
            ON p.pet_id = d.tb_pet_pet_id
        ORDER BY u.user_name
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Usuário: ' || dados.user_name ||
            ' | Pet: ' || dados.pet_name ||
            ' | Status Device: ' || dados.device_status ||
            ' | Bateria: ' || dados.device_battery
        );
    END LOOP;
END;

DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('===== CONSULTA 2 =====');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('--- ALERTAS POR PET ---');
    FOR dados IN (
        SELECT
            u.user_name,
            p.pet_name,
            COUNT(a.alert_id) AS total_alertas
        FROM TB_USER u
        INNER JOIN TB_PET p
            ON u.user_id = p.tb_user_user_id
        INNER JOIN TB_ALERT a
            ON p.pet_id = a.tb_pet_pet_id
        GROUP BY u.user_name, p.pet_name
        ORDER BY total_alertas DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Usuário: ' || dados.user_name ||
            ' | Pet: ' || dados.pet_name ||
            ' | Total Alertas: ' || dados.total_alertas
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('--- MÉDIA DE TEMPERATURA ---');
    FOR dados2 IN (
        SELECT
            p.pet_name,
            AVG(s.temperature) AS media_temperatura
        FROM TB_PET p
        INNER JOIN TB_DEVICE d
            ON p.pet_id = d.tb_pet_pet_id
        INNER JOIN TB_SENSOR_DATA s
            ON d.device_id = s.tb_device_device_id
        GROUP BY p.pet_name
        ORDER BY media_temperatura DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Pet: ' || dados2.pet_name ||
            ' | Média Temperatura: ' ||
            ROUND(dados2.media_temperatura, 2)
        );
    END LOOP;
END;

-- Bloco para  ler os dados de uma tabela e, na mesma linha,
-- mostrar o valor de uma coluna da linha atual, o valor dessa mesma coluna na 
-- linha anterior e o valor dessa mesma coluna na próxima linha
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE(
        'ID | Temperatura Atual | Temperatura Anterior | Próxima Temperatura'
    );
    FOR dados IN (
        SELECT
            sensor_id,
            temperature,
            NVL(
                TO_CHAR(
                    LAG(temperature)
                    OVER (ORDER BY sensor_id)
                ),
                'Vazio'
            ) AS temperatura_anterior,
            NVL(
                TO_CHAR(
                    LEAD(temperature)
                    OVER (ORDER BY sensor_id)
                ),
                'Vazio'
            ) AS proxima_temperatura
        FROM TB_SENSOR_DATA
        ORDER BY sensor_id
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            dados.sensor_id || ' | ' ||
            dados.temperature || ' | ' ||
            dados.temperatura_anterior || ' | ' ||
            dados.proxima_temperatura
        );
    END LOOP;
END;

-- Relatórios
DECLARE
    CURSOR c_sensor IS
        SELECT
            p.pet_name,
            s.temperature,
            s.heart_rate,
            s.activity_level
        FROM TB_SENSOR_DATA s
        INNER JOIN TB_DEVICE d
            ON s.tb_device_device_id = d.device_id
        INNER JOIN TB_PET p
            ON d.tb_pet_pet_id = p.pet_id
        ORDER BY s.temperature DESC;
    v_pet_name TB_PET.pet_name%TYPE;
    v_temperature TB_SENSOR_DATA.temperature%TYPE;
    v_heart_rate TB_SENSOR_DATA.heart_rate%TYPE;
    v_activity_level TB_SENSOR_DATA.activity_level%TYPE;
    v_total_temperatura NUMBER := 0;
    v_quantidade NUMBER := 0;
BEGIN
    OPEN c_sensor;
    LOOP
        FETCH c_sensor INTO
            v_pet_name,
            v_temperature,
            v_heart_rate,
            v_activity_level;
        EXIT WHEN c_sensor%NOTFOUND;
        v_total_temperatura :=
            v_total_temperatura + v_temperature;
        v_quantidade := v_quantidade + 1;
        DBMS_OUTPUT.PUT_LINE(
            'Pet: ' || v_pet_name ||
            ' | Temperatura: ' || v_temperature ||
            ' | Batimentos: ' || v_heart_rate
        );
        IF v_temperature >= 39 THEN
            DBMS_OUTPUT.PUT_LINE(
                'Status: TEMPERATURA CRÍTICA'
            );
        ELSIF v_temperature >= 38 THEN
            DBMS_OUTPUT.PUT_LINE(
                'Status: ALERTA'
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE(
                'Status: NORMAL'
            );
        END IF;
        DBMS_OUTPUT.PUT_LINE('-------------------');
    END LOOP;
    CLOSE c_sensor;
    DBMS_OUTPUT.PUT_LINE(
        'Média Temperatura: ' ||
        ROUND(v_total_temperatura / v_quantidade, 2)
    );
END;

DECLARE
    CURSOR c_alerta IS
        SELECT
            p.pet_name,
            a.type,
            a.alert_level
        FROM TB_ALERT a
        INNER JOIN TB_PET p
            ON a.tb_pet_pet_id = p.pet_id
        ORDER BY a.alert_level;
    v_pet_name TB_PET.pet_name%TYPE;
    v_type TB_ALERT.type%TYPE;
    v_alert_level TB_ALERT.alert_level%TYPE;
BEGIN
    OPEN c_alerta;
    LOOP
        FETCH c_alerta INTO
            v_pet_name,
            v_type,
            v_alert_level;
        EXIT WHEN c_alerta%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            'Pet: ' || v_pet_name ||
            ' | Tipo: ' || v_type ||
            ' | Nível: ' || v_alert_level
        );
        IF v_alert_level = 'CRITICAL' THEN
            DBMS_OUTPUT.PUT_LINE(
                'Ação imediata necessária.'
            );
        ELSIF v_alert_level = 'WARNING' THEN
            DBMS_OUTPUT.PUT_LINE(
                'Monitoramento recomendado.'
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE(
                'Situação controlada.'
            );
        END IF;
        DBMS_OUTPUT.PUT_LINE('-------------------');
    END LOOP;
    CLOSE c_alerta;
END;

DECLARE
    CURSOR c_device IS
        SELECT
            d.device_id,
            p.pet_name,
            d.device_battery
        FROM TB_DEVICE d
        INNER JOIN TB_PET p
            ON d.tb_pet_pet_id = p.pet_id
        ORDER BY d.device_battery DESC;
    v_device_id TB_DEVICE.device_id%TYPE;
    v_pet_name TB_PET.pet_name%TYPE;
    v_device_battery TB_DEVICE.device_battery%TYPE;
BEGIN
    OPEN c_device;
    LOOP
        FETCH c_device INTO
            v_device_id,
            v_pet_name,
            v_device_battery;
        EXIT WHEN c_device%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            'Device: ' || v_device_id ||
            ' | Pet: ' || v_pet_name ||
            ' | Bateria: ' || v_device_battery || '%'
        );
        IF v_device_battery < 70 THEN
            DBMS_OUTPUT.PUT_LINE(
                'Bateria baixa.'
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE(
                'Bateria em bom estado.'
            );
        END IF;
        DBMS_OUTPUT.PUT_LINE('-------------------');
    END LOOP;
    CLOSE c_device;
END;

DECLARE
    CURSOR c_pet IS
        SELECT
            pet_name,
            age,
            weight
        FROM TB_PET
        ORDER BY age DESC;
    v_pet_name TB_PET.pet_name%TYPE;
    v_age TB_PET.age%TYPE;
    v_weight TB_PET.weight%TYPE;
BEGIN
    OPEN c_pet;
    LOOP
        FETCH c_pet INTO
            v_pet_name,
            v_age,
            v_weight;
        EXIT WHEN c_pet%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            'Pet: ' || v_pet_name ||
            ' | Idade: ' || v_age ||
            ' | Peso: ' || v_weight
        );
        IF v_age >= 5 THEN
            DBMS_OUTPUT.PUT_LINE(
                'Pet adulto.'
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE(
                'Pet jovem.'
            );
        END IF;
        DBMS_OUTPUT.PUT_LINE('-------------------');
    END LOOP;
    CLOSE c_pet;
END;