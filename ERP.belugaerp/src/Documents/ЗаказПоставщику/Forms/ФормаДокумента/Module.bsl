#Область ОбработчикиСобытийФормы

&НаСервере
Процедура бг_ПриЧтенииНаСервереПеред(ТекущийОбъект)

	// ОбщиеМеханизмы.Паллетизация
	бг_УпаковкиЕдиницыИзмерения.ДобавитьРеквизитыПаллетизацииНаФормуДокумента(ЭтотОбъект);
	бг_УпаковкиЕдиницыИзмерения.ЗаполнитьСлужебныеЕдиницыУпаковокПаллетизации(ЭтотОбъект);
	бг_УпаковкиЕдиницыИзмерения.ЗаполнитьДанныеПаллетизацииТоваровИзФормы(ЭтотОбъект);
	бг_УпаковкиЕдиницыИзмеренияКлиентСервер.РассчитатьИтоговыеПоказателиПаллетизации(ЭтотОбъект);
	// Конец ОбщиеМеханизмы.Паллетизация

КонецПроцедуры

&НаСервере
Процедура бг_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
#Область ДобавлениеРеквизитов
	// ОбщиеМеханизмы.Паллетизация
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		бг_УпаковкиЕдиницыИзмерения.ДобавитьРеквизитыПаллетизацииНаФормуДокумента(ЭтотОбъект);
	КонецЕсли;
	// Конец ОбщиеМеханизмы.Паллетизация
#КонецОбласти // Конец ДобавлениеРеквизитов

#Область ЗаполнениеДанных
	// ОбщиеМеханизмы.Паллетизация
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		бг_УпаковкиЕдиницыИзмерения.ЗаполнитьСлужебныеЕдиницыУпаковокПаллетизации(ЭтотОбъект); 
		бг_УпаковкиЕдиницыИзмерения.ЗаполнитьДанныеПаллетизацииТоваровИзФормы(ЭтотОбъект);
		бг_УпаковкиЕдиницыИзмеренияКлиентСервер.РассчитатьИтоговыеПоказателиПаллетизации(ЭтотОбъект);
	КонецЕсли;
	// Конец ОбщиеМеханизмы.Паллетизация
#КонецОбласти // Конец ЗаполнениеДанных

#Область ДобавлениеЭлементов
	// ОбщиеМеханизмы.Паллетизация
	бг_УпаковкиЕдиницыИзмерения.ДобавитьЭлементыПаллетизацииНаФормуДокумента(ЭтотОбъект, Элементы.ГруппаТоварыПодвал);
	// Конец ОбщиеМеханизмы.Паллетизация

	бг_ДобавитьЭлементыЗагрузкиИзExcel();
	бг_ДобавитьЭлементыПоЗаказамКлиентов();
	бг_ДобавитьЭлементыДоставки();
	бг_ДобавитьКомандуЗаполнитьИзФайлаXMLОтЗаводовГруппы();
	бг_ДобавитьЭлементОплатаЗаПоставкуПослеРеализацииТовара();
#КонецОбласти // Конец ДобавлениеЭлементов

#Область УправлениеОтображением
	// ОбщиеМеханизмы.Паллетизация
	бг_УпаковкиЕдиницыИзмерения.УстановитьУсловноеОформлениеПаллетизации(ЭтотОбъект);
	бг_УпаковкиЕдиницыИзмерения.УстановитьВидимостьДоступностьЭлементовПаллетизации(ЭтотОбъект);
	// Конец ОбщиеМеханизмы.Паллетизация
#КонецОбласти // Конец УправлениеОтображением	

КонецПроцедуры  

&НаСервере
Процедура бг_ПослеЗаписиНаСервереПосле(ТекущийОбъект, ПараметрыЗаписи)
	
	// ОбщиеМеханизмы.Паллетизация
	бг_УпаковкиЕдиницыИзмерения.ЗаполнитьДанныеПаллетизацииТоваровИзФормы(ЭтотОбъект);
	// Конец ОбщиеМеханизмы.Паллетизация
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ОбработкаВыбораПосле(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументЗакупки.Форма.Форма" Тогда
		
		// ОбщиеМеханизмы.Паллетизация
		бг_ЗаполнитьДанныеПаллетизацииТоваровИзФормыНаСервере();
		бг_УпаковкиЕдиницыИзмеренияКлиентСервер.РассчитатьИтоговыеПоказателиПаллетизации(ЭтотОбъект);
		// Конец ОбщиеМеханизмы.Паллетизация
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура бг_ПартнерПриИзмененииПосле(Элемент)
	бг_ПартнерКонтрагентПриИзменении();
КонецПроцедуры

&НаКлиенте
Процедура бг_КонтрагентПриИзмененииПосле(Элемент)	
	бг_ПартнерКонтрагентПриИзменении();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура бг_ТоварыПриОкончанииРедактированияПосле(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НоваяСтрока Тогда
		// ОбщиеМеханизмы.Паллетизация
		бг_УпаковкиЕдиницыИзмеренияКлиент.ТоварыПриОкончанииРедактированияПосле(ЭтотОбъект);
		// Конец ОбщиеМеханизмы.Паллетизация
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ТоварыНоменклатураПриИзмененииПосле(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;       
	
	// ОбщиеМеханизмы.Паллетизация
	бг_УпаковкиЕдиницыИзмеренияКлиент.ТоварыНоменклатураПриИзмененииПосле(ЭтотОбъект, ТекущаяСтрока);
	// Конец ОбщиеМеханизмы.Паллетизация
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ТоварыКоличествоУпаковокПриИзмененииПосле(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;

	// ОбщиеМеханизмы.Паллетизация
	бг_УпаковкиЕдиницыИзмеренияКлиент.ТоварыКоличествоУпаковокПриИзмененииПосле(ЭтотОбъект, ТекущаяСтрока);
	// Конец ОбщиеМеханизмы.Паллетизация
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ТоварыПослеУдаленияПосле(Элемент)
	
	// ОбщиеМеханизмы.Паллетизация
	бг_УпаковкиЕдиницыИзмеренияКлиент.ТоварыПослеУдаленияПосле(ЭтотОбъект);
	// Конец ОбщиеМеханизмы.Паллетизация
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ТоварыОтмененоПриИзмененииПосле(Элемент)
	
	// ОбщиеМеханизмы.Паллетизация
	бг_УпаковкиЕдиницыИзмеренияКлиент.ТоварыОтмененоПриИзмененииПосле(ЭтотОбъект);
	// Конец ОбщиеМеханизмы.Паллетизация
	
КонецПроцедуры

// ОбщиеМеханизмы.Паллетизация
&НаКлиенте
Процедура бг_ТоварыУпаковкаПаллетаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	бг_УпаковкиЕдиницыИзмеренияКлиент.ТоварыУпаковкаПаллетаОбработкаВыбора(
		ЭтотОбъект,
		Элемент,
		ВыбранноеЗначение,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ТоварыУпаковкаПаллетаОчистка(Элемент, СтандартнаяОбработка)
	
	бг_УпаковкиЕдиницыИзмеренияКлиент.ТоварыУпаковкаПаллетаОчистка(
		ЭтотОбъект,
		Элемент,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ТоварыКоличествоПаллетПриИзменении(Элемент)
	
	бг_УпаковкиЕдиницыИзмеренияКлиент.ТоварыКоличествоПаллетПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ТоварыКоличествоКоробокПриИзменении(Элемент)

	бг_УпаковкиЕдиницыИзмеренияКлиент.ТоварыКоличествоКоробокПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ТоварыКоличествоУпаковокПриИзменении() Экспорт
	
	// Метод является эмулятором вызова типовой процедуры изменения количества товаров,
	// чтобы можно было вызвать ее из общего модуля.
	КоличествоУпаковокПриИзменении(Элементы.Товары);	

КонецПроцедуры
// Конец ОбщиеМеханизмы.Паллетизация

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура бг_ЗаказПоставщикуЗаполнитьТоварыПоЗаказамКлиента(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		ПоказатьПредупреждение(, НСтр("ru='Обработку можно вызвать только из записаного заказа поставщику'"));
		Возврат;
	КонецЕсли;
	
	ОбъектыНазначения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения(
		"бг_ЗаказПоставщикуЗаполнитьТоварыПоЗаказамКлиентаЗавершение",
		ЭтотОбъект);
	
	ОткрытьФорму("Обработка.бг_ЗаказПоставщикуЗаполнитьТоварыПоЗаказамКлиента.Форма.Форма", 
		Новый Структура("ОбъектыНазначения", ОбъектыНазначения),
		ЭтотОбъект,
		Истина,,,
		ОповещениеОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ЗаполнитьИзФайлаXMLОтЗаводовГруппы(Команда)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Выберите файл для загрузки данных заказа поставщику'");
	ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Истина;
	ДиалогВыбораФайла.Фильтр = НСтр("ru='XML файл от группы заводов (*.xml)|*.xml'");
	ДиалогВыбораФайла.ИндексФильтра = 0;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"бг_ЗагрузитьФайлXMLОтЗаводовГруппыЗавершение",
		ЭтотОбъект);
	
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);	
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ЗагрузкаИзExcel(Команда)
	
	Попытка
		ЗаблокироватьДанныеФормыДляРедактирования();
	Исключение
		ПоказатьПредупреждение(Неопределено, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Соглашение", Объект.Соглашение);
	СтруктураПараметров.Вставить("Партнер", Объект.Партнер);
	
	ОткрытьФорму(
		"Документ.ЗаказПоставщику.Форма.бг_ФормаЗагрузкиИзExcel",
		СтруктураПараметров,
		ЭтотОбъект, , , ,
		Новый ОписаниеОповещения("бг_ЗагрузкаИзExcelЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура бг_ДобавитьЭлементыЗагрузкиИзExcel()
	
	бг_ЗагрузкаИзExcel = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтаФорма,
		"бг_ЗагрузкаИзExcel",
		Элементы.ГруппаТоварыЗаполнить,
		НСтр("ru='Загрузка из Excel'"),
		"бг_ЗагрузкаИзExcel",
		"бг_ЗагрузкаИзExcel", ,
		ВидКнопкиФормы.КнопкаКоманднойПанели);
	
	бг_ЗагрузкаИзExcel.Картинка = БиблиотекаКартинок.ФорматExcel;
	
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьЭлементыПоЗаказамКлиентов()
		
	бг_ЗаказКлиента = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
		ЭтаФорма,
		"бг_ЗаказКлиента",
		Элементы.Товары,
		"Объект.Товары.бг_ЗаказКлиента",
		,
		Элементы.ТоварыНоменклатураТипНоменклатуры);
	бг_ЗаказКлиента.Видимость = Объект.бг_СозданНаОснованииЗаказовКлиента;
	бг_ЗаказКлиента.ТолькоПросмотр = Истина;
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(ЭтаФорма,
		"бг_ЗаказПоставщикуЗаполнитьТоварыПоЗаказамКлиента",
		Элементы.ГруппаТоварыЗаполнить,
		"Подобрать по заказам клиента",
		"бг_ЗаказПоставщикуЗаполнитьТоварыПоЗаказамКлиента",
		"бг_ЗаказПоставщикуЗаполнитьТоварыПоЗаказамКлиента",
		,
		ВидКнопкиФормы.КнопкаКоманднойПанели);

КонецПроцедуры  

&НаСервере
Процедура бг_ДобавитьКомандуЗаполнитьИзФайлаXMLОтЗаводовГруппы()
	
	ИмяКоманды = "бг_ЗаполнитьИзФайлаXMLОтЗаводовГруппы";
	ЗаголовокКоманды = НСтр("ru = 'Заполнить из файла XML от заводов группы';
							|en = 'Заполнить из файла XML от заводов группы'");
	
	бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьКнопкуНаФорму(
		ЭтотОбъект, 
		ИмяКоманды,
		Элементы.ГруппаТоварыЗаполнить, 
		ЗаголовокКоманды,
		ИмяКоманды, 
		ИмяКоманды, 
		, 
		ВидКнопкиФормы.КнопкаКоманднойПанели);
		
КонецПроцедуры

&НаКлиенте
Процедура бг_ЗагрузитьФайлXMLОтЗаводовГруппыЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт

	Если Не (ТипЗнч(ВыбранныеФайлы) = Тип("Массив") И ВыбранныеФайлы.Количество() = 1) Тогда
		Возврат;
	КонецЕсли;
	
 	ФайлXMLОтЗаводовГруппы = Новый ТекстовыйДокумент;
	ФайлXMLОтЗаводовГруппы.Прочитать(ВыбранныеФайлы[0], "Windows-1251");
	ТекстФайлаXMLОтЗаводовГруппы = ФайлXMLОтЗаводовГруппы.ПолучитьТекст();
	
	Если ПустаяСтрока(ТекстФайлаXMLОтЗаводовГруппы) Тогда
		Возврат;
	КонецЕсли;
	
	бг_ЗагрузитьФайлXMLОтЗаводовГруппыНаСервере(ТекстФайлаXMLОтЗаводовГруппы);
	
КонецПроцедуры

&НаСервере
// Процедура создана по аналогии с типовой процедурой ОбработкаВыбораПодборНаСервере модуля формы
//
Процедура бг_ЗагрузитьФайлXMLОтЗаводовГруппыНаСервере(ТекстФайлаXML)

	ОбъектXDTO = бг_ОбъектXDTOИзСтрокиXML(ТекстФайлаXML);
	
	ТаблицаТоваров = бг_ТаблицаТоваровИзОбъектаXDTO(ОбъектXDTO);
	
	Объект.Товары.Очистить();
	
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);
		
		Если Объект.ПоступлениеОднойДатой Тогда
			ТекущаяСтрока.ДатаПоступления = Объект.ДатаПоступления;
		КонецЕсли;
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
		СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект));
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДСВозвратнойТары", Объект.ВернутьМногооборотнуюТару);
		СтруктураДействий.Вставить("ЗаполнитьПризнакБезВозвратнойТары", Объект.ВернутьМногооборотнуюТару);
		СтруктураДействий.Вставить("ЗаполнитьПризнакОтмененоБезВозвратнойТары", Объект.ВернутьМногооборотнуюТару);
		СтруктураДействий.Вставить("ПриИзмененииТипаНоменклатуры",
			Новый Структура("ЕстьРаботы, ЕстьОтменено", Истина, Истина));
		
		НаправленияДеятельностиКлиентСервер.СтруктураДействийВставитьПриДобавленииСтроки(ЭтаФорма, СтруктураДействий);
		ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, ЭтаФорма);
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
		ДоходыИРасходыКлиентСервер.ПриДобавленииСтрокиВТаблицу(ЭтотОбъект, ТекущаяСтрока, "Объект.Товары");
	КонецЦикла;
	
	СтруктураХарактеристикиНоменклатуры = Новый Структура;
	СтруктураХарактеристикиНоменклатуры.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, СтруктураХарактеристикиНоменклатуры);
	
	ЗаполнитьПризнакСписанияНаРасходыДляУслуг();
	РассчитатьИтоговыеПоказателиЗаказа(ЭтаФорма);
	ПриИзмененииСкладаВТабличнойЧастиСервер();
	ЗаполнитьСлужебныеРеквизитыПоНазначениюВТЧ();
	МногооборотнаяТараСервер.ОбновитьСостояниеЗаполненияМногооборотнойТары(Объект.СостояниеЗаполненияМногооборотнойТары);
	
КонецПроцедуры

&НаКлиенте
Процедура бг_ЗагрузкаИзExcelЗавершение(АдресХранилища, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(АдресХранилища) Тогда
		Объект.Товары.Очистить();
		бг_ЗаполнитьТаблицуТоварыПоДаннымExcel(АдресХранилища);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура бг_ЗаполнитьТаблицуТоварыПоДаннымExcel(Адрес)
	
	ТаблицаПодобраннойНоменклатуры = ПолучитьИзВременногоХранилища(Адрес);
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ЗаполнитьНоменклатуруПартнераПоНоменклатуре", Объект.Партнер);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДСВозвратнойТары", Объект.ВернутьМногооборотнуюТару);
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать", Ложь));
	СтруктураДействий.Вставить("ЗаполнитьПризнакБезВозвратнойТары", Объект.ВернутьМногооборотнуюТару);
	СтруктураДействий.Вставить("ЗаполнитьПризнакОтмененоБезВозвратнойТары", Объект.ВернутьМногооборотнуюТару);
	СтруктураДействий.Вставить("ЗаполнитьДубликатыЗависимыхРеквизитов", ЗависимыеРеквизиты());
	
	СтруктураДействий.Вставить(
		"ПриИзмененииТипаНоменклатуры",
		Новый Структура("ЕстьРаботы, ЕстьОтменено", Истина, Истина)); 
		
	СтруктураДействий.Вставить(
		"ПроверитьЗаполнитьСклад",
		ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруЗаполненияСкладаВСтрокеТЧ(
			Объект,
			СкладГруппа));
			
	СтруктураДействий.Вставить(
		"ЗаполнитьСтавкуНДС", 
		ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект));
		
	СтруктураДействий.Вставить(
		"ЗаполнитьПризнакТипНоменклатуры", 
		Новый Структура("Номенклатура", "ТипНоменклатуры"));

	Для Каждого ПодобраннаяНоменклатура Из ТаблицаПодобраннойНоменклатуры Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПодобраннаяНоменклатура);
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(
			НоваяСтрока, 
			СтруктураДействий, 
			Неопределено);
			
		бг_УпаковкиЕдиницыИзмерения.ЗаполнитьДанныеПаллетизацииТоваровИзФормы(
			ЭтотОбъект, 
			НоваяСтрока.ПолучитьИдентификатор());
			
		бг_УпаковкиЕдиницыИзмеренияКлиентСервер.РассчитатьПоказателиПаллетизацииВСтрокеТовары(НоваяСтрока);

	КонецЦикла;
		
	РассчитатьИтоговыеПоказателиЗаказа(ЭтотОбъект);
	бг_УпаковкиЕдиницыИзмеренияКлиентСервер.РассчитатьИтоговыеПоказателиПаллетизации(ЭтотОбъект);
	
	СкладОбязателен  = ?(Объект.Товары.Итог("СкладОбязателен") = 0, 0, 1);
	
КонецПроцедуры

&НаСервере
Функция бг_ОбъектXDTOИзСтрокиXML(СтрокаXML)
	
	ЧтениеXML = Новый ЧтениеXML();
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	Возврат ОбъектXDTO;
	
КонецФункции

&НаСервере
Функция бг_ТаблицаТоваровИзОбъектаXDTO(ОбъектXDTO)
	
	СписокНоменклатурXDTO = бг_СтрокиНоменклатурыИзОбъектаXDTO(ОбъектXDTO);
	СписокТоваровXDTO = бг_СтрокиТоварыИзОбъектаXDTO(ОбъектXDTO);
	
	ИдентификаторыНоменклатуры = Новый Соответствие;
	Для Каждого НоменклатураXDTO Из СписокНоменклатурXDTO Цикл 
		ИдентификаторыНоменклатуры.Вставить(НоменклатураXDTO.ProductID, НоменклатураXDTO.CodeEK);
	КонецЦикла;
	
	ОписаниеТипаЧисло = ОбщегоНазначения.ОписаниеТипаЧисло(10,3);

	ТаблицаТоварыИзФайла = Новый ТаблицаЗначений;
	ТаблицаТоварыИзФайла.Колонки.Добавить("КодЕКНоменклатуры", ОбщегоНазначения.ОписаниеТипаСтрока(50));
	ТаблицаТоварыИзФайла.Колонки.Добавить("Количество", ОписаниеТипаЧисло);
	ТаблицаТоварыИзФайла.Колонки.Добавить("Цена", ОписаниеТипаЧисло);
	
	Для Каждого ТоварXDTO Из СписокТоваровXDTO Цикл 
		НоваяСтрокаТовары = ТаблицаТоварыИзФайла.Добавить();
		НоваяСтрокаТовары.КодЕКНоменклатуры = ИдентификаторыНоменклатуры.Получить(ТоварXDTO.ProductID);
		НоваяСтрокаТовары.Количество = ОписаниеТипаЧисло.ПривестиЗначение(ТоварXDTO.Quantity);
		НоваяСтрокаТовары.Цена = ОписаниеТипаЧисло.ПривестиЗначение(ТоварXDTO.Price);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТовары.КодЕКНоменклатуры КАК КодЕКНоменклатуры,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.Цена КАК Цена
	|ПОМЕСТИТЬ втТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УпаковкиЕдиницыИзмеренияКоробки.Владелец КАК Номенклатура,
	|	втТовары.Количество КАК Количество,
	|	втТовары.Количество КАК КоличествоУпаковок,
	|	втТовары.Цена КАК Цена,
	|	УпаковкиЕдиницыИзмеренияКоробки.Ссылка КАК бг_УпаковкаПаллета,
	|	втТовары.Количество / ЕСТЬNULL(УпаковкиЕдиницыИзмеренияКоробки.Числитель, 1) КАК бг_КоличествоКоробок,
	|	втТовары.Количество / ЕСТЬNULL(УпаковкиЕдиницыИзмеренияПаллеты.Числитель, 1) КАК бг_КоличествоПаллет
	|ИЗ
	|	втТовары КАК втТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмеренияКоробки
	|		ПО втТовары.КодЕКНоменклатуры = УпаковкиЕдиницыИзмеренияКоробки.бг_КодЕК_Номенклатуры
	|			И (УпаковкиЕдиницыИзмеренияКоробки.ЕдиницаИзмерения.бг_ТипЕдиницыИзмерения = &ТипУпаковкиКоробка
	|				И НЕ УпаковкиЕдиницыИзмеренияКоробки.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиЕдиницыИзмеренияПаллеты
	|		ПО втТовары.КодЕКНоменклатуры = УпаковкиЕдиницыИзмеренияПаллеты.бг_КодЕК_Номенклатуры
	|			И (УпаковкиЕдиницыИзмеренияПаллеты.ЕдиницаИзмерения.бг_ТипЕдиницыИзмерения = &ТипУпаковкиПаллета
	|				И НЕ УпаковкиЕдиницыИзмеренияПаллеты.ПометкаУдаления)";	
	Запрос.УстановитьПараметр("ТаблицаТовары", ТаблицаТоварыИзФайла);
	Запрос.УстановитьПараметр("ТипУпаковкиКоробка", Перечисления.бг_ТипыЕдиницИзмерения.Коробка);
	Запрос.УстановитьПараметр("ТипУпаковкиПаллета", Перечисления.бг_ТипыЕдиницИзмерения.Паллета);
	
	ТаблицаТовары = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТовары Из ТаблицаТовары  Цикл
		СтрокаТовары.бг_КоличествоКоробок = Цел(СтрокаТовары.бг_КоличествоКоробок);
		СтрокаТовары.бг_КоличествоПаллет = Цел(СтрокаТовары.бг_КоличествоПаллет);
	КонецЦикла;
	
	Возврат ТаблицаТовары;
	
КонецФункции

&НаСервере
Функция бг_СтрокиНоменклатурыИзОбъектаXDTO(ОбъектXDTO)

	СписокНоменклатурXDTO = Новый Массив;
	
	Если ТипЗнч(ОбъектXDTO.Products.Product) = Тип("СписокXDTO") Тогда
		Для Каждого СтрокаНоменклатураXDTO Из ОбъектXDTO.Products.Product Цикл 
			СписокНоменклатурXDTO.Добавить(СтрокаНоменклатураXDTO);
		КонецЦикла;
	Иначе
		СписокНоменклатурXDTO.Добавить(ОбъектXDTO.Products.Product);
	КонецЕсли;
	
	Возврат СписокНоменклатурXDTO;
	
КонецФункции

&НаСервере
Функция бг_СтрокиТоварыИзОбъектаXDTO(ОбъектXDTO)

	СписокТоваровXDTO = Новый Массив;
	
	Если ТипЗнч(ОбъектXDTO.Content.Line) = Тип("СписокXDTO") Тогда
		Для Каждого СтрокаНоменклатураXDTO Из ОбъектXDTO.Content.Line Цикл 
			СписокТоваровXDTO.Добавить(СтрокаНоменклатураXDTO);
		КонецЦикла;
	Иначе
		СписокТоваровXDTO.Добавить(ОбъектXDTO.Content.Line);
	КонецЕсли;
	
	Возврат СписокТоваровXDTO;
	
КонецФункции

&НаСервере
Процедура бг_ДобавитьЭлементыДоставки()
	бг_ПунктПогрузки = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
							ЭтотОбъект,
							"бг_ПунктПогрузки",
							Элементы.ШапкаЛево,
							"Объект.бг_ПунктПогрузки");
	бг_ПунктПогрузки.АвтоМаксимальнаяШирина = Ложь;
	бг_ПунктПогрузки.МаксимальнаяШирина     = 28;
	бг_ЗаполнитьПараметрыВыбораПунктаПогрузки();
КонецПроцедуры

&НаСервере
Процедура бг_ДобавитьЭлементОплатаЗаПоставкуПослеРеализацииТовара()

	бг_ОплатаЗаПоставкуПослеРеализацииТовара = бг_МодификацияИнтерфейсовОбщегоНазначенияСервер.ДобавитьПолеНаФорму(
													ЭтотОбъект,
													"бг_ОплатаЗаПоставкуПослеРеализацииТовара", 
													Элементы.ГруппаПараметрыПраво, 
													"Объект.бг_ОплатаЗаПоставкуПослеРеализацииТовара",,
													Элементы.ГруппаЗаказПоДаннымПоставщика, 
													"ПолеФлажка");
	
КонецПроцедуры

&НаСервере
Процедура бг_ПартнерКонтрагентПриИзменении()
	
	ПунктыНазначения = бг_ТранспортнаяЛогистика.ПунктыНазначенияПоИННГрузополучателя(Объект.Контрагент);
	
	бг_ЗаполнитьПунктПогрузки(ПунктыНазначения);
	бг_ЗаполнитьПараметрыВыбораПунктаПогрузки(ПунктыНазначения);
	
КонецПроцедуры

&НаСервере
Процедура бг_ЗаполнитьПунктПогрузки(ПунктыНазначения)

	Если ПунктыНазначения.Найти(Объект.бг_ПунктПогрузки) = Неопределено Тогда
		Объект.бг_ПунктПогрузки = Справочники.битПунктыНазначения.ПустаяСсылка();	
	КонецЕсли;
	
	Если ПунктыНазначения.Количество() = 1 Тогда
		Объект.бг_ПунктПогрузки = ПунктыНазначения[0];	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура бг_ЗаполнитьПараметрыВыбораПунктаПогрузки(ПунктыНазначения = Неопределено) 

	Если ПунктыНазначения = Неопределено Тогда
		ПунктыНазначения = бг_ТранспортнаяЛогистика.ПунктыНазначенияПоИННГрузополучателя(Объект.Контрагент);
	КонецЕсли;
	
	НовыеПараметры = Новый Массив;
	
	ПараметрВыбора = Новый ПараметрВыбора("Отбор.Ссылка", ПунктыНазначения);
	
	НовыеПараметры.Добавить(ПараметрВыбора);
	
	Элементы.бг_ПунктПогрузки.ПараметрыВыбора = Новый ФиксированныйМассив(НовыеПараметры);
		
КонецПроцедуры

&НаКлиенте
Процедура бг_ЗаказПоставщикуЗаполнитьТоварыПоЗаказамКлиентаЗавершение(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	бг_ЗаказПоставщикуЗаполнитьТоварыПоЗаказамКлиентаЗавершениеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура бг_ЗаказПоставщикуЗаполнитьТоварыПоЗаказамКлиентаЗавершениеНаСервере()
	
	бг_УпаковкиЕдиницыИзмерения.ЗаполнитьСлужебныеЕдиницыУпаковокПаллетизации(ЭтотОбъект);
	бг_УпаковкиЕдиницыИзмерения.ЗаполнитьДанныеПаллетизацииТоваровИзФормы(ЭтотОбъект);
	бг_УпаковкиЕдиницыИзмеренияКлиентСервер.РассчитатьИтоговыеПоказателиПаллетизации(ЭтотОбъект);
	
КонецПроцедуры

// ОбщиеМеханизмы.Паллетизация
&НаСервере
Процедура бг_ЗаполнитьДанныеПаллетизацииТоваровИзФормыНаСервере()

	бг_УпаковкиЕдиницыИзмерения.ЗаполнитьДанныеПаллетизацииТоваровИзФормы(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура бг_ТоварыУпаковкаПаллетаОбработкаВыбораНаСервере(ВыбраннаяУпаковкаПаллета, ИдентификаторСтрокиТовары) Экспорт

	бг_УпаковкиЕдиницыИзмерения.ТоварыУпаковкаПаллетаОбработкаВыбора(
		ЭтотОбъект,
		ВыбраннаяУпаковкаПаллета,
		ИдентификаторСтрокиТовары);

КонецПроцедуры
// Конец ОбщиеМеханизмы.Паллетизация

#КонецОбласти
