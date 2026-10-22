export async function loginUser(email: string, password: string) {
    const response = await fetch("http://localhost:3000/login", {
        method: "POST",
        body: JSON.stringify({ email, password })
    });

    if (!response.ok) {
        throw new Error("Failed to login");
    }

    const data = await response.json();
    return data;
}