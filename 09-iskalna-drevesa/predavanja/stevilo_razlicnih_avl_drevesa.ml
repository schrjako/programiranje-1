type 'a drevo =
  | Prazno
  | Sestavljeno of int * 'a drevo * 'a * 'a drevo

let prazna_mnozica = Prazno

let rec velikost drevo =
  match drevo with
  | Prazno -> 0
  | Sestavljeno (_, levi, _, desni) ->
      1 + velikost levi + velikost desni

let rec visina drevo =
match drevo with
| Prazno -> 0
| Sestavljeno (h, _, _, _) -> h

let sestavljeno (l, x, d) =
    let h = 1 + max (visina l) (visina d) in
    Sestavljeno (h, l, x, d)

let zavrti_levo = function
| Sestavljeno (_, l, x, Sestavljeno (_, dl, y, dd)) ->
    sestavljeno (sestavljeno (l, x, dl), y, dd)
| _ -> failwith "Tega drevesa ne morem zavrteti"

let zavrti_desno = function
| Sestavljeno (_, Sestavljeno (_, ll, y, ld), x, d) ->
    sestavljeno (ll, y, sestavljeno (ld, x, d))
| _ -> failwith "Tega drevesa ne morem zavrteti"

let razlika = function
    | Prazno -> 0
    | Sestavljeno (_, l, _, d) -> visina l - visina d

let uravnotezi drevo =
match drevo with
| Sestavljeno (_, l, x, d) when razlika drevo = 2 && razlika l = 1 ->
    zavrti_desno drevo
| Sestavljeno (_, l, x, d) when razlika drevo = 2 ->
    sestavljeno (zavrti_levo l, x, d) |> zavrti_desno
| Sestavljeno (_, l, x, d) when razlika drevo = -2 && razlika d = -1 ->
    zavrti_levo drevo
| Sestavljeno (_, l, x, d) when razlika drevo = -2 ->
    sestavljeno (l, x, zavrti_desno d) |> zavrti_levo
| _ -> drevo
    
let rec isci x drevo =
  match drevo with
  | Prazno -> false
  | Sestavljeno (_, levi, vrednost, desni) ->
      if x < vrednost then
        isci x levi
      else if x > vrednost then
        isci x desni
      else
        true
      
let rec dodaj x drevo =
  match drevo with
  | Prazno -> sestavljeno (Prazno, x, Prazno)
  | Sestavljeno (_, levi, vrednost, desni) ->
      if x < vrednost then
        sestavljeno (dodaj x levi, vrednost, desni) |> uravnotezi
      else if x > vrednost then
        sestavljeno (levi, vrednost, dodaj x desni) |> uravnotezi
      else
        drevo

(* ------------------------------------------------------------------------- *)

let stevilo_razlicnih xs =
  let rec aux ze_videni = function
    | [] -> velikost ze_videni
    | x :: xs -> aux (dodaj x ze_videni) xs
  in
  aux prazna_mnozica xs

let nakljucni_seznam m n = List.init n (fun _ -> Random.int m)

let seznam_zaporednih n = List.init n (fun i -> i)

let stopaj f x =
  let zacetek = Sys.time () in
  let y = f x in
  let konec = Sys.time () in
  Printf.printf "Porabljen čas: %f ms\n" (1000. *. (konec -. zacetek));
  y

let _ = Random.self_init ()

(* let primer = nakljucni_seznam 20000 20000 *)

let primer = seznam_zaporednih 10000

let n = stopaj stevilo_razlicnih primer

let _ = Printf.printf "Število različnih: %d\n" n
