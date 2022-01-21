package proto

import "github.com/hgsgtk/ngrok"

type Tcp struct{}

func NewTcp() *Tcp {
	return new(Tcp)
}

func (h *Tcp) GetName() string { return "tcp" }

func (h *Tcp) WrapConn(c ngrok.Conn, ctx interface{}) ngrok.Conn {
	return c
}
