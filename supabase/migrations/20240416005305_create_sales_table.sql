CREATE TABLE
    sales (
        id uuid PRIMARY KEY,
        gist_id uuid REFERENCES public.gists (id),
        customer_email VARCHAR NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp NOT NULL
    )