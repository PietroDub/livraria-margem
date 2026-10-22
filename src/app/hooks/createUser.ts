export async function createUser(name: string, email: string, password: string) {
    const response = await fetch("http://localhost:3000/users", {
        method: "POST",
        body: JSON.stringify({ name, email, password })
    });

    if (!response.ok) {
        throw new Error("Failed to create user");
    }

    const data = await response.json();
    return data;
}
