FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN powershell -Command "Invoke-WebRequest -Uri https://gitlab.com/chamod12/ngrok-win10-rdp/-/raw/main/Downloads.bat -OutFile Downloads.bat"
RUN Downloads.bat

ENV NGROK_AUTH_TOKEN=${{ secrets.NGROK_AUTH_TOKEN }}
RUN ngrok config add-authtoken $env:NGROK_AUTH_TOKEN

RUN Acess.bat

RUN startaudio.bat

RUN timeout /t 5400 /nobreak
