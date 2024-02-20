# Use the latest Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set the working directory
WORKDIR /app

# Download and extract ngrok
RUN Invoke-WebRequest https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -OutFile ngrok.zip && \
    Expand-Archive ngrok.zip

# Set ngrok authtoken
ARG NGROK_AUTH_TOKEN
RUN .\ngrok\ngrok.exe authtoken $NGROK_AUTH_TOKEN

# Enable Remote Desktop
RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0 && \
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop" && \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1

# Set password for runneradmin
RUN net user runneradmin P@ssw0rd! /add

# Expose port 3389 for Remote Desktop
EXPOSE 3389

# Start ngrok tunnel
CMD .\ngrok\ngrok.exe tcp 3389
