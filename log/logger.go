package log

type Logger interface {
	Debug([]interface{})
	Info([]interface{})
	Warn([]interface{})
	Error([]interface{})
	Fatal([]interface{})
}

//BaseLogger
type BLogger struct{}

func (b *BLogger) Debug([]interface{}) {}

func (b *BLogger) Info([]interface{}) {}

func (b *BLogger) Warn([]interface{}) {}

func (b *BLogger) Error([]interface{}) {}

func (b *BLogger) Fatal([]interface{}) {}
