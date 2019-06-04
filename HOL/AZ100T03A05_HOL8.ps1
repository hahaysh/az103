configuration IISInstall
{
    node "localhost"
    {
        WindowsFeature IIS
        {
            Ensure = "Present"
            Name = "Web-Server"
        }
        WindowsFeature Ftp
        {
            Ensure = "Present"
            Name = "Web-Ftp-Service"
        }
    }
}