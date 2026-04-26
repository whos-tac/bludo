# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bludo.Repo.insert!(%Bludo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Create roles if they don't exist
alias Bludo.Accounts.Role
alias Bludo.Repo

# Create admin role if it doesn't exist
if !Repo.get_by(Role, name: "admin") do
  %Role{name: "admin", permissions: %{"all" => true}}
  |> Repo.insert!()

  IO.puts("Created admin role")
end

# Create user role if it doesn't exist
if !Repo.get_by(Role, name: "user") do
  %Role{name: "user", permissions: %{}}
  |> Repo.insert!()

  IO.puts("Created user role")
end

# create a default active lti_1p3 jwk
if !Bludo.Repo.get_by(Lti13.Jwks.Jwk, id: 1) do
  %{private_key: private_key} = Lti13.Jwks.Utils.KeyGenerator.generate_key_pair()

  Lti13.Jwks.create_jwk(%{
    pem: private_key,
    typ: "JWT",
    alg: "RS256",
    kid: UUID.uuid4(),
    active: true
  })
end

# Create default admin user
alias Bludo.Accounts
alias Bludo.Accounts.User

admin_email = "ale.steiner@icloud.com"
admin_role = Repo.get_by(Role, name: "admin")

if admin_role do
  user =
    case Accounts.get_user_by_email(admin_email) do
      nil ->
        {:ok, user} =
          Accounts.register_user(%{
            email: admin_email,
            password: "Elisa2015",
            confirmed_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
          })

        user

      user ->
        user
    end

  Accounts.assign_role(user, admin_role)

  IO.puts("Admin user ensured: #{admin_email}")
else
  IO.puts("Warning: Admin role not found, skipping admin user creation")
end

