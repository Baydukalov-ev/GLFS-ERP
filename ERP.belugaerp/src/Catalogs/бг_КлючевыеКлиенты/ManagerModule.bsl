#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

Функция СсылкаСИдентификаторомCRM(ИдентификаторCRM) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	бг_КлючевыеКлиенты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.бг_КлючевыеКлиенты КАК бг_КлючевыеКлиенты
	|ГДЕ
	|	бг_КлючевыеКлиенты.ИдентификаторCRM = &ИдентификаторCRM";
	
	Запрос.УстановитьПараметр("ИдентификаторCRM", ИдентификаторCRM);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		
		Возврат Неопределено;
		
	Иначе 
		
		Возврат РезультатЗапроса.Выгрузить()[0].Ссылка;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти //СлужебныйПрограммныйИнтерфейс
	
#КонецЕсли