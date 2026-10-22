import { useState } from "react";
import { createUser } from "../hooks/createUser";
export default function CadastroUserForm() {
    const [name, setName] = useState("");
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");

    function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
        e.preventDefault();
        createUser(name, email, password).then((data) => {
            console.log(data);
        }).catch((error) => {
            console.error(error);
        });
    }

    return (
        <>
        <form onSubmit={handleSubmit}>
            <input type="text" placeholder="Nome" value={name} onChange={(e) => setName(e.target.value)} />
            <input type="email" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} />
            <input type="password" placeholder="Senha" value={password} onChange={(e) => setPassword(e.target.value)} />
            <button type="submit">Cadastrar</button>
        </form>
        </>
    )
}