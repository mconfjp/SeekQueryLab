/**
システムで利用されるSQLを記述
適当に書いていくので、これのチューニングをする。なおinsertやupdateもあるが、そういうのは適宜無視して欲しい。
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


-- 一括更新バッチ

/*
36. 作品のtotal_starとtext_lengthを一括更新
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
37. ユーザーごとのフォロワー数を一括更新
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
38. タグごとの作品数を一括更新
このSQLは、各タグが関連付けられた作品の数を一括で計算し、それをms_tagsテーブルのwork_countカラムに一括更新します。
*/
UPDATE ms_tags t
JOIN (
    SELECT tag_id, COUNT(work_id) AS work_count
    FROM work_tags
    GROUP BY tag_id
) wt ON t.tag_id = wt.tag_id
SET t.work_count = wt.work_count;






