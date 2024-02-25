/*
データ挿入後に入れるやつ
・follows
usersデータが作り終わった段階で一気に作成する必要がある。（ダブりが許されないため）
*/

-- follows
INSERT INTO follows (follow_to, follow_from, created_at, create_user_id) 
SELECT 
	u1.user_id, 
    u2.user_id, 
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    (
        SELECT
            user_id
        FROM
            users
        ORDER BY
            RAND()
        LIMIT
            10000
    ) AS u1
	CROSS JOIN 
    (
        SELECT
            user_id
        FROM
            users
        ORDER BY
            RAND()
        LIMIT
            1000
    ) AS u2
WHERE 
	u1.user_id <> u2.user_id
ORDER BY 
	RAND()
LIMIT 
	1000000;


-- work_tags
INSERT INTO work_tags (work_id, tag_id, created_at, create_user_id)
SELECT
    works.work_id,
    ms_tags.tag_id,
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    works
    CROSS JOIN ms_tags
ORDER BY 
    RAND()
LIMIT 
    100000;


-- favorites
INSERT INTO favorites (work_id, user_id, created_at, create_user_id)
SELECT
    wk.work_id,
    us.user_id,
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    (
        SELECT
            work_id,
            user_id
        FROM
            works
        ORDER BY
            RAND()
        LIMIT
            500
    ) AS wk
    CROSS JOIN 
        (
            SELECT
                user_id
            FROM
                users
            ORDER BY
                RAND()
            LIMIT
                6000
        ) AS us
        ON wk.user_id <> us.user_id
ORDER BY 
    RAND()
LIMIT 
    200000;

-- browsing_histories
INSERT INTO browsing_histories (episode_id, user_id, created_at, create_user_id)
SELECT
    ep.episode_id,
    us.user_id,
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    (
        SELECT
            episode_id
        FROM
            episodes
        ORDER BY
            RAND()
        LIMIT
            3000
    ) AS ep
    CROSS JOIN 
        (
            SELECT
                user_id
            FROM
                users
            ORDER BY
                RAND()
            LIMIT
                6000
        ) AS us
ORDER BY 
    RAND()
LIMIT 
    400000;
