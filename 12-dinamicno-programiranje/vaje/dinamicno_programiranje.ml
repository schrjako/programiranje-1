(* ========== Vaje 6: Dinamično programiranje  ========== *)


(*----------------------------------------------------------------------------*]
 Požrešna miška se nahaja v zgornjem levem kotu šahovnice. Premikati se sme
 samo za eno polje navzdol ali za eno polje na desno in na koncu mora prispeti
 v desni spodnji kot. Na vsakem polju šahovnice je en sirček. Ti sirčki imajo
 različne (ne-negativne) mase. Miška bi se rada kar se da nažrla, zato jo
 zanima, katero pot naj ubere.

 Funkcija [max_cheese cheese_matrix], ki dobi matriko [cheese_matrix] z masami
 sirčkov in vrne največjo skupno maso, ki jo bo miška požrla, če gre po
 optimalni poti.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # max_cheese test_matrix;;
 - : int = 13
[*----------------------------------------------------------------------------*)

let test_matrix = 
  [| [| 1 ; 2 ; 0 |];
     [| 2 ; 4 ; 5 |];
     [| 7 ; 0 ; 1 |] |]

let max_cheese m =
  let w = Array.length m.(0) and h = Array.length m in
  let ansarr = Array.init h (fun _ -> Array.make w 0) in
  for i = 0 to h - 1 do
    for j = 0 to w - 1 do
      if i <> 0 then ansarr.(i).(j) <- max ansarr.(i-1).(j) ansarr.(i).(j);
      if j <> 0 then ansarr.(i).(j) <- max ansarr.(i).(j-1) ansarr.(i).(j);
      ansarr.(i).(j) <- ansarr.(i).(j) + m.(i).(j)
    done
  done;
  ansarr.(h-1).(w-1)

(*----------------------------------------------------------------------------*]
 Poleg količine sira, ki jo miška lahko poje, jo zanima tudi točna pot, ki naj
 jo ubere, da bo prišla do ustrezne pojedine.

 Funkcija [optimal_path] naj vrne optimalno pot, ki jo mora miška ubrati, da se
 čim bolj nažre. Ker je takih poti lahko več, lahko funkcija vrne poljubno.
 Pripravite tudi funkcijo [convert_path], ki pot pretvori v seznam tež sirčkov
 na poti.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # optimal_path_bottom test_matrix;;
 - : mouse_direction list = [Right; Down; Down; Right; Down]
 # optimal_path test_matrix |> convert_path test_matrix;;
 - : int list = [1; 2; 4; 5; 1]
[*----------------------------------------------------------------------------*)

type mouse_direction = Down | Right

let optimal_path_bottom m =
  let w = Array.length m.(0) and h = Array.length m in
  let ansarr = Array.init h (fun _ -> Array.make w 0) in
  let dirs = Array.init h (fun _ -> Array.make w Down) in
  for i = 0 to h - 1 do
    for j = 0 to w - 1 do
      if i <> 0 && ansarr.(i-1).(j) > ansarr.(i).(j) then
        ansarr.(i).(j) <- ansarr.(i-1).(j);
      if j <> 0 && ansarr.(i).(j-1) > ansarr.(i).(j) then
        begin
          let () = ansarr.(i).(j) <- ansarr.(i).(j-1) in
          dirs.(i).(j) <- Right
        end;
      ansarr.(i).(j) <- ansarr.(i).(j) + m.(i).(j)
    done
  done;
  let rec aux acc x y =
    if x = 0 && y = 0 then acc
    else match dirs.(x).(y) with
    | Down -> aux (Down :: acc) (x-1) y
    | Right -> aux (Right :: acc) x (y-1)
  in
  aux [] (h-1) (w-1)

let convert_path m p =
  let w = Array.length m.(0) and h = Array.length m in
  let x, y, ints = List.fold_left (fun (x, y, acc) dir -> match dir with
    | Down -> (x+1, y, m.(x).(y) :: acc)
    | Right -> (x, y+1, m.(x).(y) :: acc)
    ) (0, 0, []) p in
  m.(h-1).(w-1) :: ints |> List.rev


(*----------------------------------------------------------------------------*]
 Rešujemo problem sestavljanja alternirajoče obarvanih stolpov. Imamo štiri
 različne tipe gradnikov, dva modra in dva rdeča. Modri gradniki so višin 2 in
 3, rdeči pa višin 1 in 2.

 Funkcija [alternating_towers] za podano višino vrne število različnih stolpov
 dane višine, ki jih lahko zgradimo z našimi gradniki, kjer se barva gradnikov
 v stolpu izmenjuje (rdeč na modrem, moder na rdečem itd.). Začnemo z gradnikom
 poljubne barve.

 Namig: Uporabi medsebojno rekurzivni pomožni funkciji z ukazom [and].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # alternating_towers 10;;
 - : int = 35
[*----------------------------------------------------------------------------*)

let alternating_towers v =
  let arr = Array.init 2 (fun _ -> Array.init (v+1) (fun i -> if i = 0 then 1 else 0)) in
  for i = 1 to v do
    if i >= 2 then arr.(0).(i) <- arr.(1).(i-2);
    if i >= 3 then arr.(0).(i) <- arr.(0).(i) + arr.(1).(i-3);
    if i >= 1 then arr.(1).(i) <- arr.(0).(i-1);
    if i >= 2 then arr.(1).(i) <- arr.(1).(i) + arr.(0).(i-2)
  done;
  arr.(0).(v) + arr.(1).(v)


(*----------------------------------------------------------------------------*]
 Izračunali smo število stolpov, a naše vrle gradbince sedaj zanima točna
 konfiguracija. Da ne pride do napak pri sestavljanju, bomo stolpe predstavili
 kar kot vsotne tipe. 

 Stolp posamezne barve so temelji (Bottom), ali pa kot glava bloka pripadajoče
 barve in preostanek, ki je stolp nasprotne barve.

 Definirajte funkcijo [enumerate_towers], ki vrne seznam vseh stolpov podane
 dolžine. Stolpe lahko vrne v poljubnem vrstnem redu. Funkcija naj hitro (in
 brez) prekoračitve sklada deluje vsaj do višine 20.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # enumerate_towers 4;;
 - : tower list = 
    [Red (TopRed (Red2, TopBlue (Blue2, RedBottom)));
     Red (TopRed (Red1, TopBlue (Blue3, RedBottom)));
     Red (TopRed (Red1, TopBlue (Blue2, TopRed (Red1, BlueBottom))));
     Blue (TopBlue (Blue3, TopRed (Red1, BlueBottom)));
     Blue (TopBlue (Blue2, TopRed (Red2, BlueBottom)))]
[*----------------------------------------------------------------------------*)


type blue_block = Blue3 | Blue2
type red_block = Red2 | Red1

type red_tower = TopRed of red_block * blue_tower | RedBottom
and blue_tower = TopBlue of blue_block * red_tower | BlueBottom

type tower = Red of red_tower | Blue of blue_tower

let enumerate_towers v =
  let barr = Array.init (v+1) (fun i -> if i = 0 then [BlueBottom] else [])
  and rarr = Array.init (v+1) (fun i -> if i = 0 then [RedBottom] else []) in
  for i = 1 to v do
    if i - 1 >= 0 then rarr.(i) <-
      List.map (fun bt -> TopRed (Red1, bt)) barr.(i-1) |>
      List.rev_append rarr.(i);
    if i - 2 >= 0 then rarr.(i) <-
      List.map (fun bt -> TopRed (Red2, bt)) barr.(i-2) |>
      List.rev_append rarr.(i);
    if i - 2 >= 0 then barr.(i) <-
      List.map (fun rt -> TopBlue (Blue2, rt)) rarr.(i-2) |>
      List.rev_append barr.(i);
    if i - 3 >= 0 then barr.(i) <-
      List.map (fun rt -> TopBlue (Blue3, rt)) rarr.(i-3) |>
      List.rev_append barr.(i);
  done;
  List.rev_append (List.map (fun bt -> Blue bt) barr.(v))
      (List.map (fun rt -> Red rt) rarr.(v))

(*----------------------------------------------------------------------------*]
 Vdrli ste v tovarno čokolade in sedaj stojite pred stalažo kjer so ena ob
 drugi naložene najboljše slaščice. Želite si pojesti čim več sladkorja, a
 hkrati poskrbeti, da vas ob pregledu tovarne ne odkrijejo. Da vas pri rednem
 pregledu ne odkrijejo, mora biti razdalija med dvema zaporednima slaščicama,
 ki ju pojeste vsaj `k`.

 Napišite funkcijo [ham_ham], ki sprejme seznam naravnih števil dolžine `n`, ki
 predstavljajo količino sladkorja v slaščicah v stalaži in parameter `k`,
 najmanjšo razdalijo med dvema slaščicama, ki ju še lahko varno pojeste.
 Funkcija naj vrne seznam zastavic `bool`, kjer je `i`-ti prižgan natanko tedaj
 ko v optimalni požrtiji pojemo `i`-to slaščico.

 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # ham_ham test_shelf 1;;
 - : bool list = [false; true; false; true; false; true; false; true; false]
 # ham_ham test_shelf 2;;
 - : bool list = [false; true; false; false; false; true; false; false; false]
[*----------------------------------------------------------------------------*)

let test_shelf = [1;2;-5;3;7;19;-30;1;0]

let ham_ham shelf k =
  let shelf = Array.of_list shelf in
  let dp = Array.copy shelf in
  for i = 0 to Array.length shelf - 1 do
    if i != 0 then dp.(i) <- max dp.(i) dp.(i-1);
    if i + k + 1 < Array.length shelf - 1 then dp.(i+k+1) <- dp.(i) + shelf.(i+k+1)
  done;
  dp.(Array.length dp - 1)
