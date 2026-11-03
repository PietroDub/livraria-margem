import { loginUser } from "../hooks/loginUser";
import { useState } from "react";

export default function LoginUserForm() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");

    function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
        e.preventDefault();
        loginUser(email, password).then((data) => {
            console.log(data);
        }).catch((error) => {
            console.error(error);
        });
    }

    return (
        <>
            <form onSubmit={handleSubmit}>
                <input type="email" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} />
                <input type="password" placeholder="Senha" value={password} onChange={(e) => setPassword(e.target.value)} />
                <button type="submit">Login</button>
            </form>
        </>
    )
}