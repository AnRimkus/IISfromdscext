Configuration Main
{

Param ( 
	[string] $nodeName,
	
		# Name of the website to create
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[String]$WebSiteName,
		# Source Path for Website content
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[String]$SourcePath
		
	<# Destination path for Website content
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[String]$DestinationPath
	#>
)

Import-DscResource -ModuleName PSDesiredStateConfiguration
Import-DscResource -Module xWebAdministration

Node $nodeName
  {
	  File CreateScriptsFolder {
		Type = 'Directory'
		DestinationPath = 'C:\Scriptsara'
		Ensure = "Present"
	}
	  
	  WindowsFeature WebServerRole
	{
	  Name = "Web-Server"
	  Ensure = "Present"
	}

	  

		  # Install the ASP .NET 4.5 role
		WindowsFeature AspNet45
		{
			Ensure          = "Present"
			Name            = "Web-Asp-Net45"
		}

		# Stop the default website
	   
	  xWebsite DefaultSite
		{
			Ensure          = "Present"
			Name            = "Default Web Site"
			State           = "Stopped"
			PhysicalPath    = "C:\inetpub\wwwroot"
			DependsOn       = "[WindowsFeature]WebServerRole"
		}
	  
	  <#
		# Copy the website content
		File WebContent
		{
			Ensure          = "Present"
			SourcePath      = $SourcePath
			DestinationPath = $DestinationPath
			Recurse         = $true
			Type            = "Directory"
			DependsOn       = "[WindowsFeature]AspNet45"
		}
	  #>

		# Create the new Website with HTTP
		xWebsite NewWebsite
		{
			Ensure          = "Present"
			Name            = $WebSiteName
			State           = "Started"
			PhysicalPath    = "C:\Scriptsara"
			BindingInfo     = @(
				MSFT_xWebBindingInformation
				{
					Protocol              = "HTTP"
					Port                  = 83
					#CertificateThumbprint = "71AD93562316F21F74606F1096B85D66289ED60F"
					#CertificateStoreName  = "WebHosting"
					#HostName = "test1"
				}
				<#
				MSFT_xWebBindingInformation
				{
					Protocol              = "HTTP"
					Port                  = 82
					#CertificateThumbprint = "DEDDD963B28095837F558FE14DA1FDEFB7FA9DA7"
					#CertificateStoreName  = "MY"
					HostName = "test2"
				}
				#>
			)
			}
	  
			xWebsite NewWebsite2
		{
			Ensure          = "Present"
			Name            = $WebSiteName + "2"
			State           = "Started"
			PhysicalPath    = "C:\Scriptsara2"
			BindingInfo     = @(
				MSFT_xWebBindingInformation
				{
					Protocol              = "HTTP"
					Port                  = 84
					#HostName = "test2"
				}
				
			)
			
   <# This commented section represents an example configuration that can be updated as required.
	
	WindowsFeature WebManagementConsole
	{
	  Name = "Web-Mgmt-Console"
	  Ensure = "Present"
	}
	WindowsFeature WebManagementService
	{
	  Name = "Web-Mgmt-Service"
	  Ensure = "Present"
	}
	WindowsFeature ASPNet45
	{
	  Name = "Web-Asp-Net45"
	  Ensure = "Present"
	}
	WindowsFeature HTTPRedirection
	{
	  Name = "Web-Http-Redirect"
	  Ensure = "Present"
	}
	WindowsFeature CustomLogging
	{
	  Name = "Web-Custom-Logging"
	  Ensure = "Present"
	}
	WindowsFeature LogginTools
	{
	  Name = "Web-Log-Libraries"
	  Ensure = "Present"
	}
	WindowsFeature RequestMonitor
	{
	  Name = "Web-Request-Monitor"
	  Ensure = "Present"
	}
	WindowsFeature Tracing
	{
	  Name = "Web-Http-Tracing"
	  Ensure = "Present"
	}
	WindowsFeature BasicAuthentication
	{
	  Name = "Web-Basic-Auth"
	  Ensure = "Present"
	}
	WindowsFeature WindowsAuthentication
	{
	  Name = "Web-Windows-Auth"
	  Ensure = "Present"
	}
	WindowsFeature ApplicationInitialization
	{
	  Name = "Web-AppInit"
	  Ensure = "Present"
	}
	Script DownloadWebDeploy
	{
		TestScript = {
			Test-Path "C:\WindowsAzure\WebDeploy_amd64_en-US.msi"
		}
		SetScript ={
			$source = "https://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi"
			$dest = "C:\WindowsAzure\WebDeploy_amd64_en-US.msi"
			Invoke-WebRequest $source -OutFile $dest
		}
		GetScript = {@{Result = "DownloadWebDeploy"}}
		DependsOn = "[WindowsFeature]WebServerRole"
	}
	Package InstallWebDeploy
	{
		Ensure = "Present"  
		Path  = "C:\WindowsAzure\WebDeploy_amd64_en-US.msi"
		Name = "Microsoft Web Deploy 3.6"
		ProductId = "{ED4CC1E5-043E-4157-8452-B5E533FE2BA1}"
		Arguments = "ADDLOCAL=ALL"
		DependsOn = "[Script]DownloadWebDeploy"
	}
	Service StartWebDeploy
	{                    
		Name = "WMSVC"
		StartupType = "Automatic"
		State = "Running"
		DependsOn = "[Package]InstallWebDeploy"
	} #>
  }
}
	}