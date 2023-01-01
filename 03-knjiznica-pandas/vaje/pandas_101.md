---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.14.1
  kernelspec:
    display_name: Python 3
    language: python
    name: python3
---

# Analiza podatkov s pandas

[Pandas quick-start guide](http://pandas.pydata.org/pandas-docs/stable/10min.html)  
[Pandas documentation](http://pandas.pydata.org/pandas-docs/stable/)  
[Lecture notes on pandas](../predavanja/Analiza podatkov s knjižnico Pandas.ipynb)



### Naložimo pandas in podatke

```python
# naložimo paket
import pandas as pd
import numpy as np

# ker bomo delali z velikimi razpredelnicami, povemo, da naj se vedno izpiše le 10 vrstic


# izberemo interaktivni "notebook" stil risanja

# naložimo razpredelnico, s katero bomo delali
```

Poglejmo si podatke.

```python

```

## Proučevanje podatkov

Razvrstite podatke po ocenah.

```python

```

Poberite stolpec ocen.

```python

```

Ukaza `filmi['ocena']` in `filmi[['ocena']]` sta različna:

```python
print(type(filmi['ocena']))
print(type(filmi[['ocena']]))
```

Stolpci objekta `DataFrame` so tipa `Series`. Z enojnimi oklepaji poberemo `Series`, z dvojnimi oklepaji pa `DataFrame` podtabelo. Večina operacij (grouping, joining, plotting,  filtering, ...) deluje na `DataFrame`. 

Tip `Series` se uporablja ko želimo npr. dodati stolpec.


Zaokrožite stolpec ocen z funkcijo `round()`.

```python

```

Dodajte zaokrožene vrednosti v podatke.

```python

```

Odstranite novo dodani stolpec z metodo `.drop()` z podanim `columns = ` argumentom.

```python

```

### Opomba: slice
Izbira podtabele ustvari t.i. "rezino" oz. "slice".
Slice ni kopija tabele, temveč zgolj sklic na izvorno tabelo,
in je zato ne moremo spreminjati.
Če želimo kopijo, uporabimo metodo `.copy()` na rezini, ki jo nato lahko spreminjamo.



Izberite podtabelo s stolpci `naslov`, `leto`, in `glasovi`, kateri nato dodate solpec z zaokroženimi ocenami.

```python

```

### Filtracija

Ustvarite filter, ki izbere filme, ki so izšli pred 1930, in filter za filme po 2017.
Združite ju za izbor filmov, ki so izšli pred 1930 ali po 2017.

```python

```

Definirajte funkcijo, ki preveri ali niz vsebuje kvečjemu dve besedi. Nato s pomočjo `.apply()` izberite vse filme z imeni krajšimi od dveh besed in oceno nad 8.

```python

```

### Histogrami

Združite filme po ocenah in jih preštejte.

```python

```

Naredite stolpični diagram teh podatkov.

```python

```

Tabele imajo metodo `.hist()`, ki omogoča izgradnjo histogramov za stolpce. Uporabite to metodo za prikaz poenostavljenih podatkov.

```python

```

### Izris povprečne dolžine filma glede na leto

```python

```

### Izris skupnega zasluzka za posamezno leto

```python

```
