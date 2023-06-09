#Область ПрограммныйИнтерфейс

// Функция возвращает найденный прибор учета
// 	Параметры:
// 		Код - Строка - код прибора учета
//	Возвращаемое значение:
//		СправочникСсылка.бг_ПриборыАСИиУ - найденные прибор учета
//
Функция ПриборУчетаПоКоду(Код) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Возврат Справочники.бг_ПриборыАСИиУ.НайтиПоКоду(Код);	
КонецФункции

// Функция возвращает найденный режим работы прибора учета
// 	Параметры:
// 		Код - Строка - код режима работы прибора учета
//	Возвращаемое значение:
//		СправочникСсылка.бг_РежимыРаботыПрибораАСИиУ - найденный режим работы
//
Функция РежимРаботыПрибораУчетаПоКоду(Код) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Возврат Справочники.бг_РежимыРаботыПрибораАСИиУ.НайтиПоКоду(Код);	
КонецФункции

// Функция возвращает найденную Организацию ЕГАИС 
// 	Параметры:
// 		Код - Строка - код организации ЕГАИС в классификаторе
//	Возвращаемое значение:
//		Структура - данные по организации ЕГАИС, содержит значения
//		* ОрганизацияЕГАИС - СправочникСсылка.КлассификаторОрганизацийЕГАИС, Неопределено - Организация ЕГАИС
//		* Организация - СправочникСсылка.Организации, Неопределено - Организация
//
Функция ДанныеОрганизацииЕГАИСПоКоду(Код) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Код", Код);
	Результат = Новый Структура("ОрганизацияЕГАИС, Организация");
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК ОрганизацияЕГАИС,
	|	КлассификаторОрганизацийЕГАИС.Контрагент КАК Организация
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	КлассификаторОрганизацийЕГАИС.Код = &Код
	|
	|УПОРЯДОЧИТЬ ПО
	|	КлассификаторОрганизацийЕГАИС.ПометкаУдаления";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	Возврат Результат;	
КонецФункции

// Функция возвращает найденную алкогольную продукцию
// 	Параметры:
// 		Код - Строка - код алкогольной продукции в классификаторе
//	Возвращаемое значение:
//		СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС - найденная Алкогольная продукция
//
Функция АлкогольнаяПродукцияПоКоду(Код) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Возврат Справочники.КлассификаторАлкогольнойПродукцииЕГАИС.НайтиПоКоду(Код);	
КонецФункции

#КонецОбласти 