---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.14.1
  kernelspec:
    display_name: 'Python 3.7.3 64-bit (''uvod-v-programiranje'': venv)'
    language: python
    name: python37364bituvodvprogramiranjevenv28aa9e9107484092b554440394b5e69d
---

# Delo s Pandasi

Tu notri lahko uporabljam _Markdown_ in $\LaTeX$ $$\int_a^b x \, dx$$

```python
import pandas as pd
```

```python
help(pd.read_csv)
```

```python
filmi = pd.read_csv('../../02-zajem-podatkov/predavanja/obdelani-podatki/filmi.csv')
```

```python
filmi
```

```python
filmi.ocena
```

```python
filmi.ocena[7]
```

```python
filmi.tail(10)
```

```python
filmi[4:50:3]
```

```python
filmi['dolzina']
```

```python
filmi.dolzina
```

```python
filmi[['leto', 'dolzina', 'naslov']]
```

```python
filmi
```

```python
filmi.ocena / filmi.dolzina
```

```python
filmi.ocena > 8
```

```python
filmi[filmi.ocena > 8]
```

```python
filmi.ocena > 8
```

```python
filmi.dolzina < 90
```

```python
{1, 2, 3} or {3, 4, 5}
```

```python
filmi[(filmi.ocena < 5) & (filmi.dolzina > 150)]
```

```python
filmi.ocena
```

```python
filmi.sort_values(['leto', 'ocena']).head(20)
```

```python
filmi['zanimivost'] = filmi.ocena / filmi.dolzina
```

```python
filmi
```

```python
filmi[filmi.glasovi > 500000].sort_values('zanimivost')
```

```python
filmi.mean()
```

```python
filmi.max()
```

```python
filmi[filmi.metascore == 100]
```

```python
filmi.count()
```

```python
filmi.groupby('leto')
```

```python
filmi['desetletje'] = filmi.leto // 10 * 10
```

```python
filmi
```

```python
filmi.groupby('desetletje').count()
```

```python
filmi.groupby('desetletje').size()
```

```python
filmi.groupby('leto').size().plot()
```

```python
dobri_filmi = filmi[filmi.ocena > 8.9]
```

```python
dobri_filmi.sort_values('ocena').plot.bar(x='naslov', y='ocena')
```

```python
filmi.sort_values('dolzina').plot.scatter(x='dolzina', y='ocena')

```

```python
zanri = pd.read_csv('../../02-zajem-podatkov/predavanja/obdelani-podatki/zanri.csv')
```

```python
zanri
```

```python
filmi
```

```python
filmi_z_zanri = pd.merge(filmi, zanri, left_on='id', right_on='film')
```

```python
filmi_z_zanri
```

```python
filmi_z_zanri[filmi_z_zanri.zanr == 'History'].mean()
```

```python
filmi_z_zanri[filmi_z_zanri.zanr == 'Comedy'].mean()
```

```python
filmi_z_zanri.groupby('zanr').mean().sort_values('ocena').ocena.plot.bar()
```

```python
vloge = pd.read_csv('../../02-zajem-podatkov/predavanja/obdelani-podatki/vloge.csv')
```

```python
osebe = pd.read_csv('../../02-zajem-podatkov/predavanja/obdelani-podatki/osebe.csv')
```

```python
vloge
```

```python
zanri
```

```python
pd.merge(vloge, zanri)
```

```python
vloge_z_zanri = pd.merge(vloge, zanri)
```

```python
vloge_z_zanri[vloge_z_zanri.zanr == 'Comedy']
```

```python
pd.merge(osebe, vloge_z_zanri[vloge_z_zanri.zanr == 'Comedy'], left_on='id', right_on='oseba')
```

```python
pd.merge(osebe, vloge_z_zanri[vloge_z_zanri.zanr == 'Comedy'], left_on='id', right_on='oseba').groupby('oseba').size().sort_values()
```

```python
osebe
```

```python
vloge
```

```python
zanri
```

```python
vloge_z_zanri = pd.merge(vloge, zanri)
```

```python
vloge_z_zanri.head(20)
```

```python
vloge_z_zanri[
    (vloge_z_zanri.zanr == 'Comedy')
    &
    (vloge_z_zanri.vloga == 'I')
].groupby(
    'oseba'
).size(
).sort_values(
)
```

```python
pd.merge(
    vloge_z_zanri[
        (vloge_z_zanri.zanr == 'Comedy')
        &
        (vloge_z_zanri.vloga == 'I')
    ],
    osebe,
    left_on='oseba',
    right_on='id'
).groupby(
    'ime'
).size(
).sort_values(
)

```

```python
filmi
```

```python
filmi.groupby('leto').mean()
```

```python
filmi = pd.read_csv('../../02-zajem-podatkov/predavanja/obdelani-podatki/filmi.csv', index_col='id')
```

```python
filmi
```

```python
osebe = pd.read_csv('../../02-zajem-podatkov/predavanja/obdelani-podatki/osebe.csv', index_col='id')
```

```python
osebe
```

```python
filmi.dolzina
```

```python
obrnjen_zasluzek = filmi.zasluzek[::-1]
```

```python
obrnjen_zasluzek
```

```python
filmi.zasluzek / filmi.dolzina
```

```python
obrnjen_zasluzek / filmi.dolzina
```

```python
vloge_z_zanri[
    (vloge_z_zanri.zanr == 'Comedy')
    &
    (vloge_z_zanri.vloga == 'I')
].groupby(
    'oseba'
).size(
)
```

```python
osebe['st_komedij'] = vloge_z_zanri[
    (vloge_z_zanri.zanr == 'Comedy')
    &
    (vloge_z_zanri.vloga == 'I')
].groupby(
    'oseba'
).size(
)
```

```python
osebe.sort_values('st_komedij')
```

```python
st_komedij
```

```python
len(osebe)
```

```python
osebe
```

```python
osebe.sort_values('st_komedij', na_position='first')
```

```python
osebe.dropna().sort_values('st_komedij', ascending=False).head(20).plot.bar(x='ime')
```

```python
help(osebe.sort_values)
```

```python
filmi
```

```python
zanri
```

```python

```
