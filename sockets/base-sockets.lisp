;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   Copyright (C) 2006 by Stelian Ionescu                                 ;
;                                                                         ;
;   This program is free software; you can redistribute it and/or modify  ;
;   it under the terms of the GNU General Public License as published by  ;
;   the Free Software Foundation; either version 2 of the License, or     ;
;   (at your option) any later version.                                   ;
;                                                                         ;
;   This program is distributed in the hope that it will be useful,       ;
;   but WITHOUT ANY WARRANTY; without even the implied warranty of        ;
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         ;
;   GNU General Public License for more details.                          ;
;                                                                         ;
;   You should have received a copy of the GNU General Public License     ;
;   along with this program; if not, write to the                         ;
;   Free Software Foundation, Inc.,                                       ;
;   51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (declaim (optimize (speed 2) (safety 2) (space 1) (debug 2)))
(declaim (optimize (speed 0) (safety 2) (space 0) (debug 2)))

(in-package #:net.sockets)

;;;;;;;;;;;;;;;
;;;         ;;;
;;; Sockets ;;;
;;;         ;;;
;;;;;;;;;;;;;;;

(defclass socket ()
  ((fd       :initarg :file-descriptor :reader socket-fd)
   (address  :initarg :address  :reader socket-address :type netaddr)
   (family   :initarg :family   :reader socket-family)
   (protocol :initarg :protocol :reader socket-protocol)))

(defgeneric socket-non-blocking-mode (socket))
(defgeneric (setf socket-non-blocking-mode) (value socket))

(defgeneric socket-close (socket)
  (:method-combination progn :most-specific-last))

(defgeneric socket-open-p (socket))

(defgeneric local-name (socket))

(defgeneric remote-name (socket))

(defgeneric get-socket-option (socket option-name))

(defgeneric set-socket-option (socket option-name &key))

(defclass stream-socket (socket)
  ((lisp-stream :reader socket-lisp-stream))
  (:default-initargs :type :stream))

(defclass datagram-socket (socket) ()
  (:default-initargs :type :datagram))

(defgeneric socket-unconnect (socket))

(defclass internet-socket (socket)
  ((port :reader port :type '(unsigned-byte 16)))
  (:default-initargs :family (if *ipv6* :ipv6 :ipv4)))

(defclass local-socket (socket) ()
  (:default-initargs :family :local))

(defclass active-socket (socket) ())

(defgeneric socket-connect (socket address &key &allow-other-keys))

(defgeneric socket-shutdown (socket direction))

(defgeneric socket-send (buffer socket &key
                         dont-route dont-wait no-signal
                         out-of-band &allow-other-keys))

(defgeneric socket-receive (buffer socket &key
                            out-of-band peek wait-all
                            dont-wait &allow-other-keys))

(defclass passive-socket (socket) ())

(defgeneric bind-address (socket address &key))

(defgeneric socket-listen (socket &key backlog))

(defgeneric accept-connection (passive-socket &key wait))

(defclass socket-stream-internet-active (active-socket stream-socket internet-socket) ())

(defclass socket-stream-internet-passive (passive-socket stream-socket internet-socket) ())

(defclass socket-stream-local-active (active-socket stream-socket local-socket) ())

(defclass socket-stream-local-passive (passive-socket stream-socket local-socket) ())

(defclass socket-datagram-local-active (active-socket datagram-socket local-socket) ())

(defclass socket-datagram-internet-active (active-socket datagram-socket internet-socket) ())
