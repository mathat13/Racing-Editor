Class VideoInfo {
    [string]$FullName
    [string]$BaseName
    [string]$Name
    [string]$Extension
    [string]$Directory

    # Constructor
    VideoInfo ([string] $Video) {
        $this.FullName = $Video
        $this.SetPathDerivatives($Video)
    }
    # Destructor
    [void]Delete() {}

    # Methods

    [bool]Exists () {return Test-Path -Path $this.FullName -PathType Leaf}

    [void]SetPathDerivatives([string]$Path) {
        $this.Directory = (Split-Path $Path -Parent)
        $this.BaseName = (Split-Path $Path -Leaf)   
        $this.Name = ($this.BaseName.Split('.')[0])
        $this.Extension = ($this.BaseName.Split('.')[1])
    }

    # FileSystemInfo Requirements
    
    [string]get_Name() { return "a" }
    [bool]get_Exists() {return true}
}