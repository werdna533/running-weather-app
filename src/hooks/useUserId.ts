import { useEffect, useState } from "react";

export function useUserId(): string {
  const [userId, setUserId] = useState("");

  useEffect(() => {
    let id = localStorage.getItem("user_id");
    if (!id) {
      id = crypto.randomUUID();
      localStorage.setItem("user_id", id);
    }
    setUserId(id);
  }, []);

  return userId;
}