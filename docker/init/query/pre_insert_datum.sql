

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
INSERT INTO users (user_id) SELECT 0 FROM users;

-- ランダムに更新
UPDATE
    users
SET 
    pen_name = SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 10)), 
    hashed_password = SUBSTRING(MD5(RAND()) FROM 1 FOR FLOOR(RAND() * 32)),
    created_at = ADDTIME(CONCAT_WS(' ','2023-06-01' + INTERVAL RAND() * 180 DAY, '00:00:00'), SEC_TO_TIME(FLOOR(0 + (RAND() * 86401)))),
    updated_at = NULL,
    deleted_at = NULL,
    create_user_id = 1,
    update_user_id = NULL,
    delete_user_id = NULL
;


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

