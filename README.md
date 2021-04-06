# [ScannerBarkly](https://opensea.io/collection/scannerbarkly)

1. As proud father of [Blue](https://raw.githubusercontent.com/ranveerkunal/ScannerDarkly/main/blue.jpeg)
2. As proud owner of [CryptoPunk 2074](https://www.larvalabs.com/cryptopunks/details/2074)
3. And a fan of the film [A Scanner Darkly](https://en.wikipedia.org/wiki/A_Scanner_Darkly_(film))

I always wanted to do something in the general direction of helping dogs.
This weekend i saw a clip from the movie A Scanner Darkly and decided to create this collection explained below.
All proceeds and royalties (if any :grin:) from this collection will go to [Marin Humane](https://www.marinhumane.org/get-involved/ways-to-give/) or some other dog friends in Marin County.

I was always intrigued by this [page](https://en.wikipedia.org/wiki/The_Intelligence_of_Dogs), which talks about 6 tiers of intelligence of the dogs based on a famous book.
There are in total 138 dogs in the list. I chose a colored ribbon for each tier.
```
# Scanner Darkly: red, orange, yellow, green, blue, violet
PALETTE = {
    1: color('#912318'), 
    2: color('#EE5D02'), 
    3: color('#E5ED3C'), 
    4: color('#80A82E'), 
    5: color('#496BBC'), 
    6: color('#3B3559')}
```
The shade of those colors and effects are inspired by A Scanner Darkly.
Here is the [code](https://github.com/ranveerkunal/ScannerBarkly/blob/main/py/parser.ipynb) that generated the images.

Pseudo Code:
```
1. Scrape the list from wiki page.
2. Get the info box image for each individual breed.
3. For each breed
  1. Scale the image such that the longest edge is 420.
  2. Equalize histogram.
  3. Scanner Darkly effect: Quantize image to 12 colors (K-Means using L*a*b space).
  4. Create a 500x500 background using the least common color.
  5. Add a ribbon based on the tier color.
  6. Paste the quantized image on the top of the background.
4. Write the mages to disk.
```

Why Marin County? The movie A Scanner Darkley is based on a novel about the author's experiences in the Marin County.
I have minted 138 breeds and going to put them on [sale](https://opensea.io/assets/scannerbarkly?search[resultModel]=ASSETS). I will submit the proof of donations here in this repository.
The offer price is set to 1/rank ETH (4 decimal points).

Thanks for creative inputs:

* [fernanda](https://www.instagram.com/fecalabrialage/)
* [randi](https://www.instagram.com/randihenri/)
