CREATE OR REPLACE FUNCTION add_new_user_to_profile_function() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles(id, email, username, name, avatar_url)
    VALUES (
        new.id,
        new.email,
        new.raw_user_meta_data->>'user_name',
        new.raw_user_meta_data->>'name',
        new.raw_user_meta_data->>'avatar_url'
    );
    RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY definer;