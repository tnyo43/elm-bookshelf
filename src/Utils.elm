module Utils exposing (..)

-- ---------------------------
-- List
-- ---------------------------


partition : (a -> Bool) -> List a -> ( List a, List a )
partition judge xs =
    ( List.filter judge xs, List.filter (not << judge) xs )


group : (a -> a -> Bool) -> List a -> List (List a)
group judge xs =
    let
        sub acc ys =
            case ys of
                [] ->
                    acc

                hd :: tl ->
                    let
                        ( l1, l2 ) =
                            partition (judge hd) tl
                    in
                    sub ((hd :: l1) :: acc) l2
    in
    sub [] xs
