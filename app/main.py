import os

import uvicorn as uvicorn
from fastapi import FastAPI, APIRouter

app = FastAPI()
router = APIRouter(prefix="",
                   tags=["server_setup"], )

@app.get("/setup_openvpn")
async def setup_openvpn(email: str):
    email_base = email.split("@")[0]
    os.system(f"bash bash_scripts/setup_openvpn.sh {email_base}")
    with open("my_text_file.txt", "r") as file:
        data = file.read()
    return {"ovpn": data}


@app.get("/register_client")
async def register_new_client(email: str):
    email_base = email.split("@")[0]
    os.system(f" bash generate_new_client.sh {email_base}")
    with open("my_text_file.txt", "r") as file:
        data = file.read()
    return {"ovpn": data}


@router.get("/delete_client")
async def delete_client():
    return {"1": {"1"}}


@router.get("/delete_server")
async def destroy_ovpn():
    return {"1": {"1"}}

app.include_router(router)
if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
