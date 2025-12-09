/*CREATE OR REPLACE PROCEDURE backup_schema_proc(schema_name TEXT)
LANGUAGE plpgsql AS $$
DECLARE
    backup_dir TEXT := '/backup'; -- Укажите путь к каталогу для хранения резервных копий
    db_name TEXT := postgres(); -- Текущая база данных
    backup_file TEXT;
    backup_date TEXT := TO_CHAR(CURRENT_DATE, 'YYYYDDMM');
BEGIN
    -- Формирование имени файла резервной копии
    backup_file := backup_dir || '/' || db_name || '_' || schema_name || '_' || backup_date || '.sql';

    -- Выполнение команды резервного копирования
    PERFORM pg_read_file(
        format('COPY (SELECT pg_dump(%L)) TO %L', schema_name, backup_file)
    );
    
    RAISE NOTICE 'Резервная копия схемы "%" сохранена в файл "%"', schema_name, backup_file;
END;
$$;



-- Вызов хранимой процедуры для создания резервной копии
CALL backup_schema_proc('test_schema');*/

CREATE OR REPLACE PROCEDURE backup_objects_in_schema(schema_name text)
LANGUAGE plpgsql
AS $$
DECLARE
    object_record record;
BEGIN
    FOR object_record IN
        SELECT table_name
        FROM information_schema.tables 
        WHERE table_schema = schema_name
    LOOP
        EXECUTE format('CREATE TABLE %I_backup_%s AS TABLE %I', object_record.table_name, to_char(current_date, 'YYYYMMDD'), object_record.table_name);
    END LOOP;
END;
$$;

CALL backup_objects_in_schema('public');
