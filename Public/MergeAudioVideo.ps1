Function Merge-AudioVideo {
    [Alias("musicombo")]
    param (
        $InputVideo,
        $InputAudio,
        $OutputPath
    )
    ffmpeg -i $InputVideo -i $InputAudio -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $OutputPath
}

Function Get-YTMusic {
    Param(
        [Parameter(Mandatory=$true)]$Url
    )
    youtube-dl -x --audio-format mp3 -o "youtubemusic.%(ext)s" $Url
}