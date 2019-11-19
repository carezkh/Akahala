package logstash

import (
	"encoding/json"
)

type Builder interface {
	Load(interface{})
	Marshal()([]byte,error)
	Unmarshal(b []byte)(interface{},error)
}


type BBuilder struct {
	info interface{}
}

func (b *BBuilder)Load(info interface{}){
	b.info = info
}

func (b *BBuilder)Marshal()(re []byte,err error){
	re, err = json.Marshal(b.info)
	return
}

func (b *BBuilder)Unmarshal(b []byte)(re interface{},err error){
	err = json.Unmarshal(b, &re)
	return
}
