#Область ПрограммныйИнтерфейс

// Возвращает типы налогообложения НДС, 
// относящихся к эспорту товаров (услуг)
//
//Возвращаемое значение:
// Массив 
Функция бг_ТипыНалогообложенияЭкспорта() Экспорт
	
	ТипыНалогообложения = Новый Массив;
	ТипыНалогообложения.Добавить(Перечисления.ТипыНалогообложенияНДС.ЭкспортНесырьевыхТоваров);
	ТипыНалогообложения.Добавить(Перечисления.ТипыНалогообложенияНДС.ЭкспортСырьевыхТоваровУслуг);
	ТипыНалогообложения.Добавить(Перечисления.ТипыНалогообложенияНДС.ПродажаНаЭкспорт);
	Возврат ТипыНалогообложения;
	
КонецФункции

#КонецОбласти
