/*
データの挿入
外部キー制約に引っかからないようにデータを入れていく。この処理は10回やる想定
*/


/*
ユーザ系
*/
-- users
INSERT INTO users (pen_name, hashed_password, created_at, create_user_id)
SELECT
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 10)), 
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 32)),
    ADDTIME(CONCAT_WS(' ','2020-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    users
LIMIT
    3000;


-- notifications
INSERT INTO notifications (user_id, status, type, title, body_text, created_at, create_user_id)
SELECT
    users.user_id,
    FLOOR(RAND() * 2),
    FLOOR(RAND() * 5),
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 32)),
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 100)),
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    users
ORDER BY
    RAND()
LIMIT
    3000;

/*
作品系
*/
-- works
INSERT INTO works(user_id, title, catch_copy, description, category_id, rating_type, created_at, create_user_id)
SELECT
    users.user_id,
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 50)),
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 20)),
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 150)),
    ms_categories.category_id,
    FLOOR(RAND() * 3),
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    users
    CROSS JOIN ms_categories
ORDER BY 
	RAND()
LIMIT 
	3000;


-- chapters
INSERT INTO chapters (work_id, chapter_title, status, created_at, create_user_id)
SELECT
    works.work_id,
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 50)),
    FLOOR(RAND() * 3),
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    works
ORDER BY 
    RAND()
LIMIT 
    9000;

-- episodes
INSERT INTO episodes (chapter_id, status, body_text, text_length, created_at, create_user_id)
SELECT
    chapters.chapter_id,
    FLOOR(RAND() * 2),
    @random_text := SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 10000)),
    CHAR_LENGTH(@random_text),
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    chapters
ORDER BY 
    RAND()
LIMIT 
    20000;


-- comments
-- 自己参照を簡単にやるため、繰り返して実行。usersとcross joinしてるので重たい。地獄にもSQLはあるんだなあ
INSERT INTO comments (episode_id, reply_to_id, comment_from, is_head, comment_body, created_at, create_user_id)
SELECT
    ep_alias.episode_id,
    @reply_to_id := CASE WHEN RAND() < 0.5 THEN NULL ELSE comments_alias.comment_id END, -- 非推奨の構文のためwarningが出るが今回は無視する。RAD()がある以上INTOでは実現できない。
    us.user_id,
    CASE WHEN @reply_to_id is null THEN 1 ELSE 0 END,
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 300)),
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    -- episodeとランダムに選ばれたそのコメントのLEFT JOIN
    (
        SELECT
            episode_id
        FROM
            episodes
        ORDER BY
            RAND()
        LIMIT
            1000
    ) AS ep_alias
    LEFT JOIN (
		SELECT 
			episode_id, 
            (SELECT c2.comment_id FROM comments c2 where c2.episode_id = c1.episode_id ORDER BY RAND() LIMIT 1) as comment_id
		FROM 
			comments c1 
		GROUP BY 
			episode_id) AS comments_alias
	ON ep_alias.episode_id = comments_alias.episode_id
    -- そしてcomment_fromのためにusersとcross join
    CROSS JOIN 
        (
            SELECT
                users.user_id
            FROM
                users
            ORDER BY
                RAND()
            LIMIT
                100
        ) AS us
ORDER BY 
    RAND()
LIMIT 
    15000;


-- comments
-- 自己参照を簡単にやるため、繰り返して実行。usersとcross joinしてるので重たい。地獄にもSQLはあるんだなあ
INSERT INTO comments (episode_id, reply_to_id, comment_from, is_head, comment_body, created_at, create_user_id)
SELECT
    ep_alias.episode_id,
    @reply_to_id := CASE WHEN RAND() < 0.5 THEN NULL ELSE comments_alias.comment_id END, -- 非推奨の構文のためwarningが出るが今回は無視する。RAD()がある以上INTOでは実現できない。
    us.user_id,
    CASE WHEN @reply_to_id is null THEN 1 ELSE 0 END,
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 300)),
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    -- episodeとランダムに選ばれたそのコメントのLEFT JOIN
    (
        SELECT
            episode_id
        FROM
            episodes
        ORDER BY
            RAND()
        LIMIT
            1000
    ) AS ep_alias
    LEFT JOIN (
		SELECT 
			episode_id, 
            (SELECT c2.comment_id FROM comments c2 where c2.episode_id = c1.episode_id ORDER BY RAND() LIMIT 1) as comment_id
		FROM 
			comments c1 
		GROUP BY 
			episode_id) AS comments_alias
	ON ep_alias.episode_id = comments_alias.episode_id
    -- そしてcomment_fromのためにusersとcross join
    CROSS JOIN 
        (
            SELECT
                users.user_id
            FROM
                users
            ORDER BY
                RAND()
            LIMIT
                100
        ) AS us
ORDER BY 
    RAND()
LIMIT 
    15000;


-- reviews
INSERT INTO reviews (work_id, review_from, star_rate, review_comment, created_at, create_user_id)
SELECT
    wk.work_id,
    us.user_id,
    FLOOR(RAND() * 5) + 1,
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 300)),
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    (
        SELECT
            works.work_id,
            works.user_id
        FROM
            works
        ORDER BY 
            RAND()
        LIMIT
            100
    ) AS wk
    CROSS JOIN 
    (
        SELECT
            users.user_id
        FROM
            users
        ORDER BY
            RAND()
        LIMIT
            100
    ) AS us
        ON wk.user_id <> us.user_id
ORDER BY 
    RAND()
LIMIT 
    5000;

