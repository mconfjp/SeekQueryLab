/*
データの挿入
外部キー制約に引っかからないようにデータを入れていく。マスタだけはちゃんと作って、その他のTBLはランダムで生成
*/

/*
マスタ系
*/

INSERT INTO ms_tags (tag_name, tag_description, created_at, updated_at, deleted_at, create_user_id, update_user_id, delete_user_id) 
VALUES 
('ワイルド', 'タフで恐れを知らない態度が知られる映画やキャラクター', NOW(), NULL, NULL, 1, NULL, NULL),
('精神的', '霊性や人間の精神を探求する映画やドキュメンタリー', NOW(), NULL, NULL, 1, NULL, NULL),
('涙もろい', '感動的な映画で、涙を誘う', NOW(), NULL, NULL, 1, NULL, NULL),
('エモーショナル', '感情を揺さぶる映画', NOW(), NULL, NULL, 1, NULL, NULL),
('悲しみ', '心を打つ感動的な映画', NOW(), NULL, NULL, 1, NULL, NULL),
('感動的', '心温まる映画で、笑顔になる', NOW(), NULL, NULL, 1, NULL, NULL),
('壮大', '壮大なスケールで、壮大な風景や壮大な戦闘を描いた映画', NOW(), NULL, NULL, 1, NULL, NULL),
('ハラハラする', '背筋が凍るような映画', NOW(), NULL, NULL, 1, NULL, NULL),
('リアル', 'リアルで興奮する映画', NOW(), NULL, NULL, 1, NULL, NULL),
('視覚的に美しい', '息をのむようなビジュアル効果や映像技術で知られる映画', NOW(), NULL, NULL, 1, NULL, NULL),
('シュール', '夢のようで不思議なイメージの映画', NOW(), NULL, NULL, 1, NULL, NULL),
('感動的', 'インスピレーションを与え、励まし、力強い映画', NOW(), NULL, NULL, 1, NULL, NULL),
('懐かしい', '郷愁を誘う映画', NOW(), NULL, NULL, 1, NULL, NULL),
('奇抜', '奇抜なキャラクターや独特のユーモアがある映画', NOW(), NULL, NULL, 1, NULL, NULL),
('考えさせる', '深い思考と熟考を促す映画', NOW(), NULL, NULL, 1, NULL, NULL),
('グロテスク', 'グラフィックで露骨な暴力とグロを伴う映画', NOW(), NULL, NULL, 1, NULL, NULL),
('アクション満載', 'ノンストップのアクションとアドレナリンが出る映画', NOW(), NULL, NULL, 1, NULL, NULL),
('クラシック', '時を超えた映画', NOW(), NULL, NULL, 1, NULL, NULL),
('幻想的', '幻想的で不気味な雰囲気の映画', NOW(), NULL, NULL, 1, NULL, NULL),
('気まぐれ', '遊び心のある映画', NOW(), NULL, NULL, 1, NULL, NULL),
('謎めいた', '神秘的で謎めいたストーリーの映画', NOW(), NULL, NULL, 1, NULL, NULL),
('力強い', '多様性と包括性を祝い、力を与える映画', NOW(), NULL, NULL, 1, NULL, NULL);

INSERT INTO ms_categories (major_category, sub_category, category_name, category_description, created_at, updated_at, deleted_at, create_user_id, update_user_id, delete_user_id) 
VALUES 
('フィクション', 'アドベンチャー', 'アドベンチャー物語', '刺激的な冒険と大胆さの物語', NOW(), NULL, NULL, 1, NULL, NULL),
('フィクション', 'ミステリー', 'ミステリー物語', '緊張感とミステリーに満ちた興味深い物語', NOW(), NULL, NULL, 1, NULL, NULL),
('フィクション', 'ロマンス', 'ロマンス物語', '愛と人間関係についての心温まる物語', NOW(), NULL, NULL, 1, NULL, NULL),
('フィクション', 'ファンタジー', 'ファンタジー物語', '魔法と驚きに満ちた想像力豊かな世界', NOW(), NULL, NULL, 1, NULL, NULL),
('フィクション', 'ホラー', 'ホラー物語', '背筋が凍るような恐怖を呼び起こす物語', NOW(), NULL, NULL, 1, NULL, NULL),
('フィクション', 'コメディ', 'コメディ物語', '笑いを誘う物語で、楽しませることを保証する', NOW(), NULL, NULL, 1, NULL, NULL),
('ノンフィクション', '伝記', '伝記', '実在の人物とその業績についての感動的な物語', NOW(), NULL, NULL, 1, NULL, NULL),
('ノンフィクション', 'セルフヘルプ', '自己啓発書', '成長と改善のためのガイダンスとアドバイス', NOW(), NULL, NULL, 1, NULL, NULL),
('ノンフィクション', '料理', '料理本', '美味しいレシピと料理のインスピレーション', NOW(), NULL, NULL, 1, NULL, NULL),
('ノンフィクション', '旅行', '旅行ガイド', '世界中からの冒険と経験', NOW(), NULL, NULL, 1, NULL, NULL);



/*
ユーザ系
*/
-- users
INSERT INTO users () VALUES ();
INSERT INTO users (user_id) SELECT 0 FROM users;
INSERT INTO users (user_id) SELECT 0 FROM users;
INSERT INTO users (user_id) SELECT 0 FROM users;
INSERT INTO users (user_id) SELECT 0 FROM users;
INSERT INTO users (user_id) SELECT 0 FROM users;
INSERT INTO users (user_id) SELECT 0 FROM users;
INSERT INTO users (user_id) SELECT 0 FROM users;
INSERT INTO users (user_id) SELECT 0 FROM users;
INSERT INTO users (user_id) SELECT 0 FROM users;

-- ランダムに更新
UPDATE
    users
SET 
    pen_name = SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 10)), 
    hashed_password = SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 32)),
    created_at = ADDTIME(CONCAT_WS(' ','2020-01-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),,
    updated_at = NULL,
    deleted_at = NULL,
    create_user_id = 1,
    update_user_id = NULL,
    delete_user_id = NULL;

-- follows
INSERT INTO follows (follow_to, follow_from, created_at, create_user_id) 
SELECT 
	u1.user_id, 
    u2.user_id, 
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM 
	users u1
	CROSS JOIN users u2
WHERE 
	u1.user_id <> u2.user_id
ORDER BY 
	RAND()
LIMIT 
	1000;



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
    1000;

/*
作品系
*/
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
	1000;


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
    1000;

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
    1000;

-- episodes
INSERT INTO episodes (chapter_id, status, body_text, text_length, created_at, create_user_id)
SELECT
    chapters.chapter_id,
    FLOOR(RAND() * 3),
    @random_text := SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 10000)),
    CHAR_LENGTH(@random_text),
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    chapters
ORDER BY 
    RAND()
LIMIT 
    1000;


-- comments
-- 自己参照を簡単にやるため、以下を5回繰り返して実行。usersとcross joinしてるので重たい。地獄にもSQLはあるんだなあ
INSERT INTO comments (episode_id, reply_to_id, comment_from, is_head, comment_body, created_at, create_user_id)
SELECT
    episodes.episode_id,
    @reply_to_id := CASE WHEN RAND() < 0.5 THEN NULL ELSE comments_alias.comment_id END, -- 非推奨の構文のためwarningが出るが今回は無視する。RAD()がある以上INTOでは実現できない。
    users.user_id,
    CASE WHEN @reply_to_id is null THEN 1 ELSE 0 END,
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 300)),
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    -- episodeとランダムに選ばれたそのコメントのLEFT JOIN
    episodes
    LEFT JOIN (
		SELECT 
			episode_id, 
            (SELECT c2.comment_id FROM comments c2 where c2.episode_id = c1.episode_id ORDER BY RAND() LIMIT 1) as comment_id
		FROM 
			comments c1 
		GROUP BY 
			episode_id) AS comments_alias
	ON episodes.episode_id = comments_alias.episode_id
    -- そしてcomment_fromのためにusersとcross join
    CROSS JOIN users
ORDER BY 
    RAND()
LIMIT 
    200;


-- reviews
INSERT INTO reviews (work_id, user_id,star_rate, review_comment, created_at, create_user_id)
SELECT
    works.work_id,
    users.user_id,
    FLOOR(RAND() * 5) + 1,
    SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 300)),
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    works
    CROSS JOIN users
        ON works.user_id <> users.user_id
ORDER BY 
    RAND()
LIMIT 
    1000;


-- favorites
INSERT INTO favorites (work_id, user_id, created_at, create_user_id)
SELECT
    works.work_id,
    users.user_id,
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    works
    CROSS JOIN users
        ON works.user_id <> users.user_id
ORDER BY 
    RAND()
LIMIT 
    1000;

-- browsing_histories
INSERT INTO browsing_histories (episode_id, user_id, created_at, create_user_id)
SELECT
    episodes.episode_id,
    users.user_id,
    ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    1
FROM
    episodes
    CROSS JOIN users
ORDER BY 
    RAND()
LIMIT 
    1000;
