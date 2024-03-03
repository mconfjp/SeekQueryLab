/**
システムで利用されるSQLを記述

□説明
こちらに記載のサンプルクエリを使ってチューニングができます。
としたかったんですが大体は速く動くので、意図的にチューニングできるようにしたクエリは以下です。（順次追加予定）
・request.sql内のもの
35, 37
・docker/init/query/insert_datum.sql
こちらのデータ生成用クエリは大体めちゃくちゃ重たいのでチューニング可能
*/


-- 基本機能群

/*
1. ユーザーの新規登録
*/
INSERT INTO users (pen_name, hashed_password, created_at)
VALUES ('新規ユーザー', 'ハッシュ化されたパスワード', NOW());


/*
2. ユーザーのログイン
機能の説明: 登録済みのユーザーがサイトにログインできるようにする。
*/
SELECT * FROM users
WHERE pen_name = 'ユーザー名'
AND hashed_password = 'ハッシュ化されたパスワード';


/*
3. 作品の投稿
機能の説明: ユーザーが新しい作品を投稿できるようにする。
*/
INSERT INTO works (user_id, title, catch_copy, description, category_id, rating_type, created_at)
VALUES (1, '新しい作品', 'キャッチコピー', '作品の説明', 1, 1, NOW());


/*
4. 作品の閲覧
機能の説明: ユーザーが作品を閲覧できるようにする。
*/
SELECT * FROM works
WHERE work_id = 1;


/*
5. タグの検索
機能の説明: 特定のタグに関連する作品を検索できるようにする。
*/
SELECT works.* FROM works
JOIN work_tags ON works.work_id = work_tags.work_id
JOIN ms_tags ON work_tags.tag_id = ms_tags.tag_id
WHERE ms_tags.tag_name = 'タグ名';


/*
6. 作品の評価
機能の説明: ユーザーが作品に評価（スターの数）をつけることができるようにする。
*/
UPDATE works
SET total_star = total_star + 1
WHERE work_id = 1;


/*
7. 作品のコメント
機能の説明: ユーザーが作品にコメントできるようにする。
*/
INSERT INTO comments (episode_id, reply_to_id, comment_from, is_head, comment_body, created_at)
VALUES (1, NULL, 1, 1, 'コメントの本文', NOW());


/*
8. お気に入り登録
機能の説明: ユーザーが作品をお気に入り登録できるようにする。
*/
INSERT INTO favorites (work_id, user_id, created_at)
VALUES (1, 1, NOW());


/*
9. ユーザーのフォロー
機能の説明: ユーザーが他のユーザーをフォローできるようにする。
*/
INSERT INTO follows (follow_to, follow_from, created_at)
VALUES (2, 1, NOW());


/*
10. 通知の送信
機能の説明: システムからユーザーに対して通知を送信できるようにする。
*/
INSERT INTO notifications (user_id, status, type, title, body_text, created_at)
VALUES (1, 1, 1, '通知のタイトル', '通知の本文', NOW());


-- 一括表示ページ

/*
11. タグの一覧表示
機能の説明: 登録されているタグを一覧表示する。
*/
SELECT * FROM ms_tags;


/*
12. カテゴリの一覧表示
機能の説明: 登録されているカテゴリを一覧表示する。
*/
SELECT * FROM ms_categories;


/*
13. 作品の検索
機能の説明: キーワードやタグ、カテゴリなどを用いて作品を検索できるようにする。
*/
SELECT * FROM works
WHERE title LIKE '%キーワード%'
OR description LIKE '%キーワード%';


/*
14. ユーザーの一覧表示
機能の説明: 登録されているユーザーを一覧表示する。
*/
SELECT * FROM users;


/*
15. ユーザーのプロフィール表示
機能の説明: 特定のユーザーのプロフィールを表示する。
*/
SELECT * FROM users
WHERE user_id = 1;


/*
16. ユーザーの作品一覧表示
機能の説明: 特定のユーザーが投稿した作品を一覧表示する。
*/
SELECT * FROM works
WHERE user_id = 1;


/*
17. 作品のランキング表示
機能の説明: 作品のランキングを表示する。
*/
Copy code
SELECT * FROM works
ORDER BY total_star DESC;


/*
18. 最新の作品表示
機能の説明: 最新の作品を表示する。
*/
SELECT * FROM works
ORDER BY created_at DESC;


/*
19. お気に入り作品の一覧表示
機能の説明: 特定のユーザーがお気に入り登録した作品を一覧表示する。
*/
SELECT * FROM favorites
JOIN works ON favorites.work_id = works.work_id
WHERE favorites.user_id = 1;


/*
20. コメントの一覧表示
機能の説明: 特定の作品に対するコメントを一覧表示する。
*/
SELECT * FROM comments
WHERE episode_id = 1;


-- 多少複雑な処理

/*
21. 人気のタグの取得
機能の説明: 最も多くの作品に関連付けられているタグを取得する。
このクエリは、作品とタグの間の多対多の関係を結合し、タグごとの作品の数をカウントしています。そのため、大量のデータがある場合や適切なインデックスがない場合にクエリが重くなる可能性があります。
*/
SELECT ms_tags.tag_name, COUNT(work_tags.work_id) AS tag_count
FROM ms_tags
JOIN work_tags ON ms_tags.tag_id = work_tags.tag_id
GROUP BY ms_tags.tag_id
ORDER BY tag_count DESC;

/*
22. ユーザーごとの作品数の取得
機能の説明: 各ユーザーが投稿した作品の数を取得する。
このクエリは、ユーザーと作品の間の1対多の関係を結合し、各ユーザーごとの作品の数をカウントしています。ユーザー数や作品数が増えるにつれて、クエリの実行時間が増加する可能性があります。
*/
SELECT users.user_id, users.pen_name, COUNT(works.work_id) AS work_count
FROM users
LEFT JOIN works ON users.user_id = works.user_id
GROUP BY users.user_id;

/*
23. ユーザーごとのお気に入り作品数の取得
機能の説明: 各ユーザーがお気に入り登録した作品の数を取得する。
このクエリは、ユーザーとお気に入りの間の1対多の関係を結合し、各ユーザーごとのお気に入り作品の数をカウントしています。ユーザー数やお気に入り作品数が増えるにつれて、クエリの実行時間が増加する可能性があります。
*/
SELECT users.user_id, users.pen_name, COUNT(favorites.work_id) AS favorite_count
FROM users
LEFT JOIN favorites ON users.user_id = favorites.user_id
GROUP BY users.user_id;

/*
24. 最新のコメントの取得
機能の説明: 最新のコメントを取得する。
このクエリは、コメントを作成日時の降順で並べ替えて、最新の10件を取得しています。コメント数が増えるにつれて、クエリの実行時間が増加する可能性があります。
*/
SELECT * FROM comments
ORDER BY created_at DESC
LIMIT 10;


/*
25. 作品の平均評価の取得
機能の説明: 各作品の平均評価を取得する。
このクエリは、作品ごとの評価の平均を計算しています。評価数が増えるにつれて、クエリの実行時間が増加する可能性があります。
*/
SELECT work_id, AVG(star_rate) AS average_rating
FROM reviews
GROUP BY work_id;

/*
26. 作品ごとの平均評価とコメント数の取得
機能の説明: 各作品の平均評価とコメント数を取得する。
このクエリは、作品ごとの平均評価とコメント数を取得しています。複数のテーブルを結合して集計を行うため、データ量が増えるにつれてクエリの実行時間が増加する可能性があります。
*/
SELECT works.work_id, AVG(reviews.star_rate) AS average_rating, COUNT(comments.comment_id) AS comment_count
FROM works
LEFT JOIN reviews ON works.work_id = reviews.work_id
LEFT JOIN episodes ON works.work_id = episodes.work_id
LEFT JOIN comments ON episodes.episode_id = comments.episode_id
GROUP BY works.work_id;

/*
27. 最もコメントの多い作品の取得
機能の説明: コメントが最も多い作品を取得する。
このクエリは、コメントの数が最も多い作品を取得しています。全ての作品とコメントを結合して集計を行うため、データ量が増えるにつれてクエリの実行時間が増加する可能性があります。
*/
SELECT works.work_id, COUNT(comments.comment_id) AS comment_count
FROM works
LEFT JOIN episodes ON works.work_id = episodes.work_id
LEFT JOIN comments ON episodes.episode_id = comments.episode_id
GROUP BY works.work_id
ORDER BY comment_count DESC
LIMIT 1;


/*
28. 最も長い作品の取得
機能の説明: 最も文字数が多い作品を取得する。
このクエリは、作品ごとに最大の文字数を持つエピソードを取得しています。全てのエピソードを作品ごとに集計しているため、データ量が増えるにつれてクエリの実行時間が増加する可能性があります。
*/
SELECT work_id, MAX(text_length) AS max_text_length
FROM episodes
GROUP BY work_id
ORDER BY max_text_length DESC
LIMIT 1;

/*
29. 特定ユーザーのフォロワー数の取得
機能の説明: 特定のユーザーのフォロワー数を取得する。
このクエリは、特定のユーザーのフォロワー数を取得しています。フォローの情報を特定のユーザーごとに集計しているため、データ量が増えるにつれてクエリの実行時間が増加する可能性があります。
*/
SELECT follow_to, COUNT(follow_from) AS follower_count
FROM follows
WHERE follow_to = 1
GROUP BY follow_to;

/*
30. ユーザーごとの通知数の取得
機能の説明: 各ユーザーが受信した通知の数を取得する。
このクエリは、各ユーザーが受信した通知の数を取得しています。通知の情報をユーザーごとに集計しているため、データ量が増えるにつれてクエリの実行時間が増加する可能性があります。
*/
SELECT user_id, COUNT(notification_id) AS notification_count
FROM notifications
GROUP BY user_id;

-- 若干重ためのクエリ

/*
31. 人気の作品ランキングクエリ:
*/

SELECT w.title, AVG(r.star_rate) AS average_rating
FROM works w
JOIN reviews r ON w.work_id = r.work_id
WHERE w.deleted_at IS NULL
GROUP BY w.work_id
ORDER BY average_rating DESC
LIMIT 10; -- 上位10作品を取得

/*
32. トレンド作品ランキングクエリ (最近人気が急上昇している作品):
*/
SELECT w.title, COUNT(b.episode_id) AS view_count
FROM works w
JOIN chapters c ON w.work_id = c.work_id
JOIN episodes e ON c.chapter_id = e.chapter_id
JOIN browsing_histories b ON e.episode_id = b.episode_id
WHERE w.deleted_at IS NULL
AND b.created_at >= DATE_SUB(CURRENT_DATE(), INTERVAL 170 DAY) -- 直近7日間の閲覧履歴を対象にする
GROUP BY w.work_id
ORDER BY view_count DESC
LIMIT 10; -- 上位10作品を取得

/*
33. ユーザーごとのお気に入りランキングクエリ:
*/
SELECT u.pen_name, COUNT(f.work_id) AS favorite_count
FROM users u
JOIN favorites f ON u.user_id = f.user_id
GROUP BY u.user_id
ORDER BY favorite_count DESC
LIMIT 10; -- 上位10ユーザーを取得

/*
34. カテゴリ別人気作品ランキングクエリ:
*/

SELECT c.category_name, w.title, COUNT(b.episode_id) AS view_count
FROM ms_categories c
JOIN works w ON c.category_id = w.category_id
JOIN chapters ch ON w.work_id = ch.work_id
JOIN episodes e ON ch.chapter_id = e.chapter_id
JOIN browsing_histories b ON e.episode_id = b.episode_id
WHERE w.deleted_at IS NULL
AND b.created_at >= DATE_SUB(CURRENT_DATE(), INTERVAL 380 DAY) -- 直近30日間の閲覧履歴を対象にする
GROUP BY c.category_id, w.work_id
ORDER BY view_count DESC
LIMIT 10; -- 各カテゴリごとに上位10作品を取得

/*
35. 人気タグのランキング
この半年でサイト上で最も人気のあるタグをランキング化し、ユーザーが人気のあるトピックやジャンルを把握できるようにします。
*/

SELECT t.tag_name, COUNT(wt.created_at) AS tag_count
FROM ms_tags t
JOIN work_tags wt ON t.tag_id = wt.tag_id and wt.created_at >= DATE_SUB(CURRENT_DATE(), INTERVAL 180 DAY)
GROUP BY t.tag_id
ORDER BY tag_count DESC
LIMIT 10; -- 上位10タグを取得


/*
36. アクティブユーザーの取得
最近にアクティブなユーザーを抽出し、サイト上での活動が活発なユーザーを特定します。活動の多いユーザーはコミュニティにおいて重要な存在となる場合があります。
*/

SELECT u.pen_name, COUNT(DISTINCT w.work_id) AS active_works_count
FROM users u
JOIN works w ON u.user_id = w.user_id
JOIN episodes e ON w.work_id = e.work_id
WHERE e.created_at >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY) -- 直近30日間に新しいエピソードを公開したユーザーを対象にする
GROUP BY u.user_id
ORDER BY active_works_count DESC
LIMIT 10; -- 上位10アクティブユーザーを取得

/*
37. コメントの活発な作品ランキング
コメント数が多い作品をランキングし、ユーザーがコミュニティでの活発な議論や交流が行われている作品を見つけやすくします。
*/

SELECT
    w.title,
    COUNT(c.comment_id) AS comment_count
FROM
    works w
    JOIN
        chapters ch
    ON  w.work_id = ch.work_id
    JOIN
        episodes e
    ON  ch.chapter_id = e.chapter_id
    JOIN
        comments c
    ON  e.episode_id = c.episode_id
WHERE
    e.status = 0
GROUP BY
    w.work_id
ORDER BY
    comment_count DESC
LIMIT 10
;

/*
38. 平均章ごとのコメント数ランキング
各章ごとの平均コメント数が多い作品をランキングし、物語の展開や興味深いシーンがある箇所を示します。
*/

SELECT w.title, AVG(comment_count) AS avg_comments_per_chapter
FROM works w
JOIN chapters ch ON w.work_id = ch.work_id
LEFT JOIN (
    SELECT e.chapter_id, COUNT(c.comment_id) AS comment_count
    FROM episodes e
    JOIN comments c ON e.episode_id = c.episode_id
    GROUP BY e.chapter_id
) AS chapter_comments ON ch.chapter_id = chapter_comments.chapter_id
GROUP BY w.work_id
ORDER BY avg_comments_per_chapter DESC
LIMIT 10; -- 上位10作品を取得

/*
39. ユーザーのフォロワー数の取得
ユーザーごとのフォロワー数を取得し、ユーザーの影響力や人気度を示します。
*/

SELECT u.pen_name, COUNT(f.follow_to) AS follower_count
FROM users u
LEFT JOIN follows f ON u.user_id = f.follow_to
GROUP BY u.user_id
ORDER BY follower_count DESC
LIMIT 10; -- 上位10ユーザーを取得

/*
40. 最新作品の取得
最新の作品を取得し、ユーザーが最新のコンテンツをチェックできるようにします。
*/

SELECT title, created_at
FROM works
ORDER BY created_at DESC
LIMIT 10; -- 最新の10作品を取得


/*
41. トップレビュアーの取得
最も多くのレビューを行っているユーザーを取得し、信頼できるレビュアーやコンテンツの評価者を特定します。
*/

SELECT u.pen_name, COUNT(r.review_id) AS review_count
FROM users u
JOIN reviews r ON u.user_id = r.review_from
GROUP BY u.user_id
ORDER BY review_count DESC
LIMIT 10; -- 上位10ユーザーを取得


/*
42. 作品の平均評価ランキング
作品ごとの平均評価が高いものをランキングし、高品質なコンテンツをユーザーに紹介します。
*/

SELECT w.title, AVG(r.star_rate) AS avg_rating
FROM works w
JOIN reviews r ON w.work_id = r.work_id
GROUP BY w.work_id
ORDER BY avg_rating DESC
LIMIT 10; -- 上位10作品を取得

/*
43. ユーザーの活動履歴の取得
ユーザーが最近行った活動 (作品の投稿、コメント、レビューなど) を取得し、ユーザーの興味や行動傾向を把握します。
*/

SELECT u.pen_name, MAX(activity_time) AS last_activity_time
FROM (
    SELECT user_id, MAX(created_at) AS activity_time
    FROM (
        SELECT user_id, created_at FROM works
        UNION ALL
        SELECT comment_from AS user_id, created_at FROM comments
        UNION ALL
        SELECT review_from AS user_id, created_at FROM reviews
    ) AS all_activities
    GROUP BY user_id
) AS user_activities
JOIN users u ON user_activities.user_id = u.user_id
GROUP BY u.user_id
ORDER BY last_activity_time DESC
LIMIT 10; -- 上位10ユーザーの最新の活動を取得

/*
44. 最も長い作品の取得
テキストの長さが最も長い作品を取得し、長編作品や大規模なストーリーを探すユーザーに役立ちます。
*/

SELECT title, text_length
FROM works
ORDER BY text_length DESC
LIMIT 1; -- 最も長い作品を取得


-- 一括更新バッチ

/*
45. 作品のtotal_starとtext_lengthを一括更新
このSQLは、エピソードごとの作品のtotal_starとtext_lengthの合計を計算し、それらの合計値をworksテーブルの対応するカラムに一括更新します。
*/
UPDATE works w
JOIN (
    SELECT work_id, SUM(total_star) AS total_star, SUM(text_length) AS total_text_length
    FROM episodes
    GROUP BY work_id
) e ON w.work_id = e.work_id
SET w.total_star = e.total_star,
    w.text_length = e.total_text_length;

/*
46. ユーザーごとのフォロワー数を一括更新
このSQLは、フォローされたユーザーごとのフォロワー数を一括で計算し、それをusersテーブルのfollower_countカラムに一括更新します。
*/
UPDATE users u
JOIN (
    SELECT follow_to, COUNT(follow_from) AS follower_count
    FROM follows
    GROUP BY follow_to
) f ON u.user_id = f.follow_to
SET u.follower_count = f.follower_count;


/*
47. タグごとの作品数を一括更新
このSQLは、各タグが関連付けられた作品の数を一括で計算し、それをms_tagsテーブルのwork_countカラムに一括更新します。
*/
UPDATE ms_tags t
JOIN (
    SELECT tag_id, COUNT(work_id) AS work_count
    FROM work_tags
    GROUP BY tag_id
) wt ON t.tag_id = wt.tag_id
SET t.work_count = wt.work_count;






