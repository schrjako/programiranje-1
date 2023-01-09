type point = { x : int; y : int }
type par = { l : point; r : point }
type matrix = { m : int array array; b : par array array }

let id n = Array.init n (fun x -> Array.make n 0)

let init_m (i : int array array) =
  let n = Array.length i in
  { m = i; b = Array.init n (fun x -> Array.init n (fun y -> { l = {x=(-1);y=(-1)}; r = {x=(-1);y=(-1)}})) }

let mmult (m1 : matrix) (m2 : matrix) : matrix =
  let n = Array.length m1.m in
  if n != Array.length m2.m || Array.length m1.m.(0) != Array.length m2.m.(0) || n != Array.length m1.m.(0) then
    failwith "matrix multiplication matrices should be square";
  let m, b = Array.init n (fun x ->
    Array.init n (fun y ->
      Array.init n (fun z -> (m1.m.(x).(z) + m2.m.(z).(y), {l = {x=x;y=z}; r = {x=z;y=y}})) |>
      Array.fold_left (fun (accel, accpar) (cel, cpar) -> if accel < cel then (cel, cpar) else (accel, accpar))
      (-1, {l={x=0;y=0};r={x=0;y=0}})
    )
  ) |> Array.map Array.split |> Array.split in
  { m = m; b = b}

let mmax (m : matrix) : int =
  Array.fold_left (Array.fold_left max) 0 m.m

let sq (m : matrix) : matrix = mmult m m

let print_m (m : matrix) : unit =
  Array.iter (fun row -> Printf.printf "( "; Array.iter (Printf.printf " %4d ") row; Printf.printf ")\n") m.m;
  Array.iter (fun row -> Printf.printf "( "; Array.iter (fun p -> Printf.printf " %d,%d|%d,%d " p.l.x p.l.y p.r.x p.r.y) row; Printf.printf ")\n") m.b;
  print_endline ""

let (|||) a b = Int.logor a b
let (>>>) a b = Int.shift_left a b

let msb a =
  let a = a ||| (a >>> 1) in
  let a = a ||| (a >>> 2) in
  let a = a ||| (a >>> 4) in
  let a = a ||| (a >>> 8) in
  let a = a ||| (a >>> 16) in
  let a = a ||| (a >>> 32) in
  (a + 1) >>> 1

let pow (m : matrix) p =
  let n = Array.length m.m in
  let pw2 = ref [m;init_m (id n)] and i = ref 2 in
  while !i <= p do
    pw2 := (sq (List.hd !pw2)) :: !pw2;
    i := !i * 2;
    (*Printf.printf "i: %d\n" !i*)
  done;
  let pw2 = List.rev !pw2 |> Array.of_list in
  Array.iter print_m pw2;
  let ans = ref [init_m (id n)] and i = ref 1 and cp = ref p in
  let used = ref [0] in
  while !cp != 0 do
    if !cp mod 2 = 1 then
      begin
        ans := (mmult (List.hd !ans) pw2.(!i)) :: !ans;
        used := !i :: !used
      end;
    i := !i + 1;
    cp := !cp / 2
  done;
  Printf.printf "answers\n";
  List.iter print_m !ans;
  let mp = ref {x=0;y=0} in
  let final = List.hd !ans in
  Array.iteri (fun x row -> Array.iteri (fun y el -> if final.m.(!mp.x).(!mp.y) < el then mp := {x=x;y=y}) row) final.m;
  let rec reconstructp2 (p : point) (i : int) acc =
    Printf.printf "reconstructing p2: %d,%d %d\n" p.x p.y i;
    if i = 0 then acc
    else if i = 1 then p :: acc
    else reconstructp2 pw2.(i).b.(p.x).(p.y).l (i-1) (reconstructp2 pw2.(i).b.(p.x).(p.y).r (i-1) acc)
  in
  let rec aux (p : point) acc = function
    | ([], []) -> acc
    | (fp2 :: tailp2, f :: tail) -> aux f.b.(p.x).(p.y).l (reconstructp2 f.b.(p.x).(p.y).r fp2 acc) (tailp2, tail)
  in
  (final.m.(!mp.x).(!mp.y), aux !mp [] (!used, !ans) |>
    List.map (fun {x=x;y=y} -> {x=x+1;y=y+1}))

let k = init_m [|[|5;25;3;2|];
          [|1;4;25;1|];
          [|2;1;3;2|];
          [|4;1;40;5|]|]

let cm = 6

(*let () = print_m (pow k cm)*)
(*let () = Printf.printf "%d\n" (mmax (pow k cm))*)
