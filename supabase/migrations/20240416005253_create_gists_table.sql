CREATE TABLE
    gists (
        id uuid PRIMARY KEY,
        profile_id uuid REFERENCES public.profiles (id),
        is_paid BOOLEAN NOT NULL,
        title VARCHAR NOT NULL,
        description VARCHAR NOT NULL,
        lang VARCHAR NOT NULL,
        price INTEGER NOT NULL,
        content TEXT NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp NOT NULL
    )