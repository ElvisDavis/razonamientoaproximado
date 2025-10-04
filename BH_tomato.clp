;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BH_tomato.clp - Base de Hechos (FuzzyCLIPS) para ejemplo Mamdani
;; Entradas de ejemplo: Temperatura=32°C, HumedadSuelo=35%, HumedadAire=85%
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(reset)

; Fuzzificación "singleton triple": (x 0) (x 1) (x 0)
(assert (Temperatura  (32 0) (32 1) (32 0)))
(assert (HumedadSuelo (35 0) (35 1) (35 0)))
(assert (HumedadAire  (85 0) (85 1) (85 0)))

(run)

(facts)
