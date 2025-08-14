

USE master


GO

DECLARE @Tipos_Figura TABLE(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL
);

INSERT INTO @Tipos_Figura (Nombre)
VALUES
('Círculo'),
('Cuadrado'),
('Rectángulo');

DECLARE @Figuras TABLE(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Id_Tipo_Figura INT,
    Radio DECIMAL(18,2),
    Largo DECIMAL(18,2),
    Ancho DECIMAL(18,2),
    Area DECIMAL(18,2),
    Volumen DECIMAL(18,2)
);

INSERT INTO @Figuras (Id_Tipo_Figura, Radio, Largo, Ancho, Area, Volumen)
VALUES
(1, 5.00, NULL, NULL, NULL, NULL),  -- Círculo
(2, NULL, 4.00, NULL, NULL, NULL),  -- Cuadrado
(3, NULL, 6.0, 3.00, NULL, NULL);   -- Rectángulo


DECLARE Figura_Cursor CURSOR FOR SELECT Id, Id_Tipo_Figura, Radio, Largo, Ancho FROM @Figuras;
DECLARE @Area DECIMAL(18,2), @Volumen DECIMAL(18,2);

DECLARE @Id INT, @Id_Tipo_Figura INT, @Radio DECIMAL(18,2), @Largo DECIMAL(18,2), @Ancho DECIMAL(18,2);

OPEN Figura_Cursor;

FETCH NEXT FROM Figura_Cursor INTO @Id, @Id_Tipo_Figura, @Radio, @Largo, @Ancho;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @Id_Tipo_Figura = 1 -- Círculo
    BEGIN
        SET @Area = PI() * POWER(@Radio, 2);
        SET @Volumen = NULL; -- No aplica para círculo
    END
    ELSE IF @Id_Tipo_Figura = 2 -- Cuadrado
    BEGIN
        SET @Area = POWER(@Largo, 2);
        SET @Volumen = NULL; -- No aplica para cuadrado
    END
    ELSE IF @Id_Tipo_Figura = 3 -- Rectángulo
    BEGIN
        SET @Area = @Largo * @Ancho;
        SET @Volumen = NULL; -- No aplica para rectángulo
    END

    UPDATE @Figuras 
    SET Area = @Area, Volumen = @Volumen 
    WHERE Id = @Id;

    FETCH NEXT FROM Figura_Cursor INTO @Id, @Id_Tipo_Figura, @Radio, @Largo, @Ancho;
END

CLOSE Figura_Cursor;
DEALLOCATE Figura_Cursor;

-- Mostrar resultados

SELECT f.Id, tf.Nombre, f.Area
FROM @Figuras f
INNER JOIN @Tipos_Figura tf 
  ON tf.Id = f.Id_Tipo_Figura 
ORDER BY f.Id;
