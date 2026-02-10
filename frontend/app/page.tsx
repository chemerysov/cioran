"use client";

import { useState, useEffect } from "react";

export default function Page() {
    const [data, setData] = useState(null);

    useEffect(() => {
        fetch("/api/") 
            .then((res) => res.json())
            .then((json) => setData(json))
            .catch((err) => console.error("Fetch failed:", err));
    }, []);

    return (
        <div>
            <pre>
                {data ? JSON.stringify(data, null, 2) : "Loading..."}
            </pre>
        </div>
    );
}