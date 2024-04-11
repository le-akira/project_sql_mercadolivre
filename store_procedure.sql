CREATE PROCEDURE atualizar_status_itens()
BEGIN
    DECLARE last_update_date DATE;
    DECLARE current_date DATE;

    SET last_update_date = (SELECT MAX(data_atualizacao) FROM ItemStatus);
    SET current_date = CURRENT_DATE;

    IF last_update_date IS NULL OR last_update_date < current_date THEN
        INSERT INTO ItemStatus (item_id, status, data_atualizacao)
        SELECT i.id, i.status, current_date
        FROM Item i;
    END IF;
END PROCEDURE;