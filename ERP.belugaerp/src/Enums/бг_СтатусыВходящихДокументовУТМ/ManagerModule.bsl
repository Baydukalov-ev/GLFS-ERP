
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает статусы входящих документом УТМ, подлежащих обработке
//
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.бг_СтатусыВходящихДокументовУТМ
//
Функция КОбработке() Экспорт
	Возврат ОбщегоНазначенияБЗККлиентСервер.ЗначенияВМассиве(Зарегистрирован, ПустаяСсылка());
КонецФункции

#КонецОбласти

#КонецЕсли
