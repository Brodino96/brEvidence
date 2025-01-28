CREATE TABLE `br_evidence` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `id` LONGTEXT NOT NULL,
    `pickup` TINYINT(1),
    `tags` LONGTEXT DEFAULT "[]" NOT NULL,
    `prop` LONGTEXT NOT NULL,
    `coords` LONGTEXT DEFAULT '{"x": 0, "y": 0, "z": 0, "heading": 0}' NOT NULL,
    `model` LONGTEXT NOT NULL,
    `offset` LONGTEXT DEFAULT '{"x": 0, "y": 0, "z": 0}' NOT NULL,
    `distance` INT DEFAULT 0 NOT NULL,
    `title` LONGTEXT NOT NULL,
    `description`LONGTEXT NOT NULL
)