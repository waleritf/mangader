Script for downloading mangas from mangareader.xyz

Works from ruby console.
Initialize class `Mangader` with manga's name and call `download`. It creates new directory with manga's name in your home dir and splits it by chapters.

Example:

Mangader.new('watashi-wa-shingo').download

Tested only on Linux
