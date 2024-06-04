SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `bd_turnos` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `bd_turnos`;
-- -----------------------------------------------------
-- Table `bd_turnos`.`areas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`areas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre_area` VARCHAR(100) NOT NULL,
  `estatus` TINYINT NOT NULL,
  `create_by` VARCHAR(30) NOT NULL,
  `create_at` DATETIME NOT NULL,
  `update_by` VARCHAR(30) NULL,
  `update_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `ID_Area_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `bd_turnos`.`cajas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`cajas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre_caja` VARCHAR(30) NOT NULL,
  `estatus` TINYINT NOT NULL,
  `create_by` VARCHAR(30) NOT NULL,
  `create_at` DATETIME NOT NULL,
  `update_by` VARCHAR(30) NULL,
  `update_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `ID_Caja_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `bd_turnos`.`configuracion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`configuracion` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `clave` INT NOT NULL,
  `valor` VARCHAR(40) NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  `estatus` TINYINT NOT NULL,
  `create_by` VARCHAR(30) NOT NULL,
  `create_at` DATETIME NOT NULL,
  `update_by` VARCHAR(30) NULL,
  `update_at` DATETIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `bd_turnos`.`turnos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`turnos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `create_by` VARCHAR(30) NOT NULL,
  `create_at` DATETIME NOT NULL,
  `turno_seleccionado` DATETIME NULL,
  `turno_atendido` DATETIME NULL,
  `estatus` VARCHAR(10) NOT NULL,
  `update_by` VARCHAR(30) NULL,
  `update_at` DATETIME NULL,
  `fk_idarea` INT NOT NULL,
  `fk_idcaja` INT NULL, -- Permitir valores nulos
  PRIMARY KEY (`id`, `fk_idarea`),
  INDEX `fk_turno_area1_idx` (`fk_idarea` ASC) VISIBLE,
  INDEX `fk_turnos_cajas1_idx` (`fk_idcaja` ASC) VISIBLE,
  CONSTRAINT `fk_turno_area1`
    FOREIGN KEY (`fk_idarea`)
    REFERENCES `bd_turnos`.`areas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_turnos_cajas1`
    FOREIGN KEY (`fk_idcaja`)
    REFERENCES `bd_turnos`.`cajas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `bd_turnos`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`usuarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre_usuario` VARCHAR(30) NOT NULL,
  `contraseña` VARCHAR(64) NOT NULL,
  `estatus` TINYINT NOT NULL,
  `create_by` VARCHAR(30) NOT NULL,
  `create_at` DATETIME NOT NULL,
  `update_by` VARCHAR(30) NULL,
  `update_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `ID_Usuarios_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `nombre_usuario_UNIQUE` (`nombre_usuario` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
#El collate permite cambiar el tipo de caracteres que maneja, en este caso se cambia para que permita diferenciar
#Mayusculas de minusculas 
ALTER TABLE usuarios CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
-- -----------------------------------------------------
-- Table `bd_turnos`.`cajas_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`cajas_usuarios` (
  `id` INT NOT NULL,
  `usuarios_id` INT NOT NULL,
  `cajas_id` INT NOT NULL,
  `estatus` TINYINT NOT NULL,
  PRIMARY KEY (`id`, `usuarios_id`, `cajas_id`),
  INDEX `fk_usuarios_has_cajas_cajas1_idx` (`cajas_id` ASC) VISIBLE,
  INDEX `fk_usuarios_has_cajas_usuarios1_idx` (`usuarios_id` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  CONSTRAINT `fk_usuarios_has_cajas_usuarios1`
    FOREIGN KEY (`usuarios_id`)
    REFERENCES `bd_turnos`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuarios_has_cajas_cajas1`
    FOREIGN KEY (`cajas_id`)
    REFERENCES `bd_turnos`.`cajas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table `bd_turnos`.`folios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`folios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `numero_folio` INT NOT NULL,
  `estatus` TINYINT NOT NULL,
  `fecha_de_folio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` VARCHAR(30) NOT NULL,
  `create_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` VARCHAR(30) NULL,
  `update_at` DATETIME NULL,
  `fk_idturno` INT NOT NULL,
  PRIMARY KEY (`id`, `fk_idturno`),
  INDEX `fk_folios_turnos2_idx` (`fk_idturno` ASC) VISIBLE,
  CONSTRAINT `fk_folios_turnos2`
    FOREIGN KEY (`fk_idturno`)
    REFERENCES `bd_turnos`.`turnos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `bd_turnos`.`area_cajas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`area_cajas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `area_id` INT NOT NULL,
  `caja_id` INT NOT NULL,
  `estatus` TINYINT NOT NULL,
  PRIMARY KEY (`id`, `area_id`, `caja_id`),
  INDEX `fk_caja_has_area_area1_idx` (`area_id` ASC) VISIBLE,
  INDEX `fk_caja_has_area_caja1_idx` (`caja_id` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  CONSTRAINT `fk_caja_has_area_caja1`
    FOREIGN KEY (`caja_id`)
    REFERENCES `bd_turnos`.`cajas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_caja_has_area_area1`
    FOREIGN KEY (`area_id`)
    REFERENCES `bd_turnos`.`areas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `bd_turnos`.`permisos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`permisos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(150) NOT NULL,
  `estatus` TINYINT NOT NULL,
  `create_by` VARCHAR(30) NOT NULL,
  `create_at` DATETIME NOT NULL,
  `update_by` VARCHAR(30) NULL,
  `update_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `ID_Usuarios_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `bd_turnos`.`permisos_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`permisos_usuarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `permisos_id` INT NOT NULL,
  `usuarios_id` INT NOT NULL,
  `estatus` TINYINT NOT NULL,
  PRIMARY KEY (`id`, `permisos_id`, `usuarios_id`),
  INDEX `fk_permisos_has_usuarios_usuarios1_idx` (`usuarios_id` ASC) VISIBLE,
  INDEX `fk_permisos_has_usuarios_permisos1_idx` (`permisos_id` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  CONSTRAINT `fk_permisos_has_usuarios_permisos1`
    FOREIGN KEY (`permisos_id`)
    REFERENCES `bd_turnos`.`permisos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_permisos_has_usuarios_usuarios1`
    FOREIGN KEY (`usuarios_id`)
    REFERENCES `bd_turnos`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `bd_turnos`.`datos_personales_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`datos_personales_usuarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombres` VARCHAR(100) NOT NULL,
  `primer_apellido` VARCHAR(50) NOT NULL,
  `segundo_apellido` VARCHAR(50) NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  `estatus` TINYINT NOT NULL,
  `fk_idusuario` INT NOT NULL,
  PRIMARY KEY (`id`, `fk_idusuario`),
  INDEX `fk_datos_personales_usuarios_usuarios1_idx` (`fk_idusuario` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  CONSTRAINT `fk_datos_personales_usuarios_usuarios1`
    FOREIGN KEY (`fk_idusuario`)
    REFERENCES `bd_turnos`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `bd_turnos`.`area_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_turnos`.`area_usuarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `area_id` INT NOT NULL,
  `usuario_id` INT NOT NULL,
  `estatus` TINYINT NOT NULL,
  PRIMARY KEY (`id`, `area_id`, `usuario_id`),
  INDEX `fk_areas_has_usuarios_usuarios1_idx` (`usuario_id` ASC) VISIBLE,
  INDEX `fk_areas_has_usuarios_areas1_idx` (`area_id` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  CONSTRAINT `fk_areas_has_usuarios_areas1`
    FOREIGN KEY (`area_id`)
    REFERENCES `bd_turnos`.`areas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_areas_has_usuarios_usuarios1`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `bd_turnos`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;