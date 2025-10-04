;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BC_tomato.clp - Base de Conocimientos (FuzzyCLIPS, Mamdani)
;; Dominio: Control de invernadero de tomate
;; Entradas: Temperatura(°C 10..45), HumedadSuelo(% 0..100), HumedadAire(% 30..100)
;; Salidas:  Riego(0..100), Ventilacion(0..100)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ------------- Definición de universos y términos borrosos -------------
(deftemplate Temperatura
  10 45 celsius
  ((Baja  (10 1) (18 1) (22 0))
   (Media (18 0) (25 1) (32 0))
   (Alta  (28 0) (35 1) (45 1))))

(deftemplate HumedadSuelo
  0 100
  ((Seca   (0 1) (0 1) (30 0))
   (Media  (20 0) (45 1) (70 0))
   (Humeda (60 0) (100 1) (100 1))))

(deftemplate HumedadAire
  30 100
  ((Baja  (30 1) (40 1) (60 0))
   (Media (50 0) (70 1) (85 0))
   (Alta  (80 0) (100 1) (100 1))))

(deftemplate Riego
  0 100
  ((Nulo  (0 1) (0 1) (10 0))
   (Bajo  (10 0) (30 1) (50 0))
   (Medio (40 0) (60 1) (80 0))
   (Alto  (70 0) (90 1) (100 1))))

(deftemplate Ventilacion
  0 100
  ((Nula  (0 1) (0 1) (10 0))
   (Baja  (10 0) (30 1) (50 0))
   (Media (40 0) (60 1) (80 0))
   (Alta  (70 0) (90 1) (100 1))))

; ------------- Reglas (10) -------------
; 1) Suelo seco + T alta -> riego alto, ventilación media
(defrule R1
  (HumedadSuelo Seca)
  (Temperatura Alta)
  =>
  (assert (Riego Alto))
  (assert (Ventilacion Media)))

; 2) Suelo seco + T media -> riego medio
(defrule R2
  (HumedadSuelo Seca)
  (Temperatura Media)
  =>
  (assert (Riego Medio)))

; 3) Suelo seco + aire baja -> riego medio
(defrule R3
  (HumedadSuelo Seca)
  (HumedadAire Baja)
  =>
  (assert (Riego Medio)))

; 4) Suelo húmedo -> riego nulo
(defrule R4
  (HumedadSuelo Humeda)
  =>
  (assert (Riego Nulo)))

; 5) Aire alta + suelo húmedo -> riego nulo, ventilación baja
(defrule R5
  (HumedadAire Alta)
  (HumedadSuelo Humeda)
  =>
  (assert (Riego Nulo))
  (assert (Ventilacion Baja)))

; 6) Aire alta + T alta -> ventilación alta
(defrule R6
  (HumedadAire Alta)
  (Temperatura Alta)
  =>
  (assert (Ventilacion Alta)))

; 7) T media + aire media -> ventilación media
(defrule R7
  (Temperatura Media)
  (HumedadAire Media)
  =>
  (assert (Ventilacion Media)))

; 8) T baja -> ventilación nula
(defrule R8
  (Temperatura Baja)
  =>
  (assert (Ventilacion Nula)))

; 9) Suelo medio + aire baja -> riego bajo
(defrule R9
  (HumedadSuelo Media)
  (HumedadAire Baja)
  =>
  (assert (Riego Bajo)))

; 10) Aire alta + suelo seco -> riego bajo (control de hongos)
(defrule R10
  (HumedadAire Alta)
  (HumedadSuelo Seca)
  =>
  (assert (Riego Bajo)))

; ------------- Defuzzificación (centroide) -------------
(defrule Defuzz_Riego
  (declare (salience -5))
  ?r <- (Riego ?)
  =>
  (bind ?val (moment-defuzzify ?r))
  (printout t crlf ">> RIEGO recomendado (centroide): " ?val crlf))

(defrule Defuzz_Vent
  (declare (salience -6))
  ?v <- (Ventilacion ?)
  =>
  (bind ?val (moment-defuzzify ?v))
  (printout t ">> VENTILACION recomendada (centroide): " ?val crlf))
