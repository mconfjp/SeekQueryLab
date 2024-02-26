/*
Table作成
*/

-- マスタ系
CREATE TABLE `ms_tags` (
    `tag_id` int unsigned NOT NULL AUTO_INCREMENT,
    `tag_name` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL,
    `tag_description` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
PRIMARY KEY (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `ms_categories` (
    `category_id` int unsigned NOT NULL AUTO_INCREMENT,
    `major_category` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL, -- 正規化可能だが、要素の追加等が少ないのでこのまま
    `sub_category` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL,
    `category_name` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL,
    `category_description` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



-- ユーザーのかたまり

CREATE TABLE `users` (
    `user_id` int unsigned NOT NULL AUTO_INCREMENT,
    `pen_name` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL,
    `hashed_password` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `follows` (
    `follow_to` int unsigned NOT NULL,
    `follow_from` int unsigned NOT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
    PRIMARY KEY (`follow_to`, `follow_from`),
    FOREIGN KEY (`follow_to`)
        REFERENCES users(`user_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    FOREIGN KEY (`follow_from`)
        REFERENCES users(`user_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `notifications` (
    `notification_id` int unsigned NOT NULL AUTO_INCREMENT,
    `user_id` int unsigned NOT NULL,
    `status` int NOT NULL, -- 1 or 2
    `type` int NOT NULL, -- 1~5
    `title` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
    `body_text` varchar(300) COLLATE utf8mb4_bin DEFAULT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
    PRIMARY KEY (`notification_id`),
    FOREIGN KEY (`user_id`)
        REFERENCES users(`user_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


-- 作品のかたまり

CREATE TABLE `works` (
    `work_id` int unsigned NOT NULL AUTO_INCREMENT,
    `user_id` int unsigned NOT NULL,
    `title` varchar(100) COLLATE utf8mb4_bin NOT NULL,
    `catch_copy` varchar(45) COLLATE utf8mb4_bin DEFAULT NULL,
    `description` varchar(300) COLLATE utf8mb4_bin DEFAULT NULL,
    `category_id` int unsigned NOT NULL,
    `rating_type` int NOT NULL ,
    `text_length` int NOT NULL DEFAULT '0',
    `total_star` int NOT NULL DEFAULT '0',
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
    PRIMARY KEY (`work_id`),
    FOREIGN KEY (`user_id`)
        REFERENCES users(`user_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    FOREIGN KEY (`category_id`)
        REFERENCES ms_categories(`category_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `work_tags` (
    `work_id` int unsigned NOT NULL,
    `tag_id` int unsigned NOT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
    PRIMARY KEY (`work_id`, `tag_id`),
    FOREIGN KEY (`work_id`)
        REFERENCES works(`work_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    FOREIGN KEY (`tag_id`)
        REFERENCES ms_tags(`tag_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `chapters` (
    `chapter_id` int unsigned NOT NULL AUTO_INCREMENT,
    `work_id` int unsigned NOT NULL,
    `chapter_title` varchar(100) COLLATE utf8mb4_bin NOT NULL,
    `status` int NOT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
PRIMARY KEY (`chapter_id`),
    FOREIGN KEY (`work_id`)
        REFERENCES works(`work_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `episodes` (
    `episode_id` int unsigned NOT NULL AUTO_INCREMENT,
    `chapter_id` int unsigned NOT NULL,
    `status` int NOT NULL,
    `body_text` varchar(15000) COLLATE utf8mb4_bin DEFAULT NULL,
    `text_length` int NOT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
PRIMARY KEY (`episode_id`),
    FOREIGN KEY (`chapter_id`)
        REFERENCES chapters(`chapter_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `comments` (
    `comment_id` int unsigned NOT NULL AUTO_INCREMENT,
    `episode_id` int unsigned NOT NULL,
    `reply_to_id` int unsigned DEFAULT NULL,
    `comment_from` int unsigned NOT NULL,
    `is_head` boolean NOT NULL,
    `comment_body` varchar(300) COLLATE utf8mb4_bin DEFAULT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
PRIMARY KEY (`comment_id`),
    FOREIGN KEY (`episode_id`)
        REFERENCES episodes(`episode_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    FOREIGN KEY (`reply_to_id`)
        REFERENCES comments(`comment_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    FOREIGN KEY (`comment_from`)
        REFERENCES users(`user_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `reviews` (
    `review_id` int unsigned NOT NULL AUTO_INCREMENT,
    `work_id` int unsigned NOT NULL,
    `review_from` int unsigned NOT NULL,
    `star_rate` int unsigned NOT NULL,
    `review_comment` varchar(300) COLLATE utf8mb4_bin DEFAULT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
PRIMARY KEY (`review_id`),
    FOREIGN KEY (`work_id`)
        REFERENCES works(`work_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    FOREIGN KEY (`review_from`)
        REFERENCES users(`user_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


-- ユーザーと作品のかたまり

CREATE TABLE `favorites` (
    `work_id` int unsigned NOT NULL,
    `user_id` int unsigned NOT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
PRIMARY KEY (`work_id`, `user_id`),
    FOREIGN KEY (`work_id`)
        REFERENCES works(`work_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    FOREIGN KEY (`user_id`)
        REFERENCES users(`user_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `browsing_histories` (
    `episode_id` int unsigned NOT NULL,
    `user_id` int unsigned NOT NULL,
    `created_at` datetime DEFAULT NULL,
    `updated_at` datetime DEFAULT NULL,
    `deleted_at` datetime DEFAULT NULL,
    `create_user_id` int unsigned DEFAULT NULL,
    `update_user_id` int unsigned DEFAULT NULL,
    `delete_user_id` int unsigned DEFAULT NULL,
PRIMARY KEY (`episode_id`, `user_id`),
    FOREIGN KEY (`episode_id`)
        REFERENCES episodes(`episode_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    FOREIGN KEY (`user_id`)
        REFERENCES users(`user_id`)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

