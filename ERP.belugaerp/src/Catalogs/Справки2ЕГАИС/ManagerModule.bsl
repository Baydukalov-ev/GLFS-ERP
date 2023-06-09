#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
	
Функция бг_ВидЛицензииАлкогольнойПродукцииСправки2(Справка2ЕГАИС) Экспорт

	Если Не ЗначениеЗаполнено(Справка2ЕГАИС) Тогда
		Возврат Перечисления.ВидыЛицензийАлкогольнойПродукции.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Справки2ЕГАИС.АлкогольнаяПродукция.ВидПродукции.ВидЛицензии КАК ВидЛицензии
	|ИЗ
	|	Справочник.Справки2ЕГАИС КАК Справки2ЕГАИС
	|ГДЕ
	|	Справки2ЕГАИС.Ссылка = &Справка2ЕГАИС";
	
	Запрос.УстановитьПараметр("Справка2ЕГАИС", Справка2ЕГАИС);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ВидЛицензии;
	КонецЕсли;

КонецФункции

#КонецОбласти

#КонецЕсли
