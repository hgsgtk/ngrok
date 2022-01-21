package proto

import "github.com/hgsgtk/ngrok"

type Protocol interface {
	GetName() string
	WrapConn(ngrok.Conn, interface{}) ngrok.Conn
}
