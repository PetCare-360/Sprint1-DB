set verify off;
set serveroutput on;

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